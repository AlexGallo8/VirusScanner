class Auth0Controller < ApplicationController
  def callback
    auth_info = request.env['omniauth.auth']
    Rails.logger.debug "Auth Info: #{auth_info.inspect}"  # Debug log

    # Estrai i dati principali
    auth0_uid = auth_info['uid']
    email = auth_info['info']['email']
    username = auth_info['info']['nickname']

    # Trova utenti con email o UID corrispondente
    local_user = User.find_by(email: email)
    auth0_user = User.find_by(auth0_uid: auth0_uid)

    if auth0_user
      # L'utente Auth0 esiste già
      Rails.logger.debug "Auth0 user found: #{auth0_user.inspect}"
      login(auth0_user)
    elsif local_user
      # Esiste un utente locale con la stessa email
      if local_user.auth0_uid.nil?
        # Fonde l'account locale con quello Auth0
        Rails.logger.debug "Merging local user with Auth0: #{local_user.inspect}"
        local_user.update(auth0_uid: auth0_uid, auth_provider: 'auth0', username: username)
        if auth_info['provider'] == 'google_oauth2'
          google_credentials = auth_info['credentials']
          local_user.update!(
            google_token: google_credentials['token'],
            google_refresh_token: google_credentials['refresh_token'],
            google_token_expires_at: Time.at(google_credentials['expires_at'])
          )
        end
        
        login(local_user)
      
      else
        # Caso improbabile: l'utente locale ha già un altro UID Auth0
        Rails.logger.error "Conflict: Local user with email #{email} already linked to another Auth0 UID."
        redirect_to root_path, alert: 'Errore: email già collegata a un altro account'
        return
      end
    else
      # Nessun utente trovato, crea un nuovo account
      Rails.logger.debug "Creating new Auth0 user..."
      user = User.create(
        email: email,
        username: username,
        auth0_uid: auth0_uid,
        auth_provider: 'auth0',
        password_digest: SecureRandom.hex(10) # Genera una password casuale
      )
      
      if user.persisted?
        Rails.logger.debug "New user created successfully: #{user.inspect}"
        if auth_info['provider'] == 'google_oauth2'
          google_credentials = auth_info['credentials']
          user.update!(
            google_token: google_credentials['token'],
            google_refresh_token: google_credentials['refresh_token'],
            google_token_expires_at: Time.at(google_credentials['expires_at'])
          )
        end
        login(user)
      else
        Rails.logger.error "Failed to save new user: #{user.errors.full_messages}"
        redirect_to root_path, alert: 'Registrazione fallita'
        return
      end
    end

    # Redirect dopo login o registrazione
    redirect_to root_path
  rescue => e
    Rails.logger.error "Error in callback: #{e.message}"  # Debug log
    redirect_to root_path, alert: 'Si è verificato un errore durante la registrazione'
  end

  def failure
    redirect_to root_path, alert: 'Autenticazione fallita'
  end

  def logout
    session[:userinfo] = nil
    url = URI::HTTPS.build(
      host: Rails.application.credentials.auth0[:domain],
      path: '/v2/logout',
      query: {
        returnTo: root_url,
        client_id: Rails.application.credentials.auth0[:client_id]
      }.to_query
    ).to_s

    redirect_to url, allow_other_host: true, status: :see_other
  end
end

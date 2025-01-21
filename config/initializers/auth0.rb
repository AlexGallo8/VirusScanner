# Aggiungi queste linee all'inizio del file
OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    Rails.application.credentials.auth0[:client_id],
    Rails.application.credentials.auth0[:client_secret],
    Rails.application.credentials.auth0[:domain],
    callback_path: '/auth/auth0/callback',
    authorize_params: {
        redirect_uri: 'http://localhost:3000/auth/auth0/callback',
        scope: 'openid profile email'
    }
  )

  provider(
    :google_oauth2,
    Rails.application.credentials.google[:client_id],
    Rails.application.credentials.google[:client_secret],
    {
      scope: 'email profile https://www.googleapis.com/auth/drive.readonly',
      access_type: 'offline',
      prompt: 'consent'
    }
  )
end
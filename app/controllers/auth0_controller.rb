class Auth0Controller < ApplicationController
  def callback
    auth_info = request.env['omniauth.auth']
    user = User.find_or_create_by(email: auth_info['info']['email']) do |u|
      u.provider = auth_info['provider'] 
      u.uid = auth_info['uid']
      u.password_digest = SecureRandom.hex(10)
    end
    
    login(user)
    redirect_to root_path
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
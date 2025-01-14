class ApplicationController < ActionController::Base
  
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :auth0_callback?

  private

  def auth0_callback?
    controller_name == 'auth0' && action_name == 'callback'
  end

  def authenticate_user!
    redirect_to root_path, alert: "You must be loggrf in to do that." unless user_signed_in?
  end

  def current_user
    Current.user ||= authenticate_user_from_session
  end
  helper_method :current_user
  
  def authenticate_user_from_session
    User.find_by(id: session[:user_id])
  end
  
  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

  def user_signed_in_with_google?
    user_signed_in? && Current.user.auth0_uid&.start_with?("google-oauth2")
  end
  helper_method :user_signed_in_with_google?

  def login(user)
    Current.user = user
    reset_session
    session[:user_id] = user.id
  end

  def logout(user)
    Current.user = nil
    reset_session
  end
end
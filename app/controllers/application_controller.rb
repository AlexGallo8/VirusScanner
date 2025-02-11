class ApplicationController < ActionController::Base
  include UserLogging
  
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :auth0_callback?

  private

  def auth0_callback?
    controller_name == 'auth0' && action_name == 'callback'
  end

  def authenticate_user!
    redirect_to root_path, alert: "You must be logged in to do that." unless user_signed_in?
  end

  def current_user
    Current.user ||= authenticate_user_from_session || authenticate_user_from_remember_token
  end
  helper_method :current_user
  
  def authenticate_user_from_session
    User.find_by(id: session[:user_id])
  end

  def authenticate_user_from_remember_token
    if (remember_token = cookies.encrypted[:remember_token])
      Rails.logger.debug "Attempting to authenticate with remember token"
      user = User.find_by(remember_token: remember_token)
      if user&.remembered_and_valid?
        Rails.logger.debug "Valid remember token found for user: #{user.email}"
        user
      else
        Rails.logger.debug "Invalid or expired remember token"
        cookies.delete(:remember_token)
        nil
      end
    end
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
    old_token = cookies.encrypted[:remember_token]
    reset_session
    session[:user_id] = user.id
    cookies.encrypted[:remember_token] = old_token if old_token
  end

  def logout(user)
    user&.forget_me!
    cookies.delete(:remember_token)
    Current.user = nil
    reset_session
  end
end
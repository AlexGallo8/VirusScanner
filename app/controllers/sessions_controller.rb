class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def new
  end
  
  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      if params[:remember_me] == '1'
        user.remember_me!
        cookies.permanent.encrypted[:remember_token] = {
          value: user.remember_token,
          expires: 2.weeks.from_now,
          httponly: true,
          same_site: :lax
        }
      end
      
      login user
      
      Rails.logger.debug "User logged in: #{user.email} (ID: #{user.id})"
      
      respond_to do |format|
        format.html { redirect_to root_path, notice: "You have signed in successfully." }
        format.json { render json: { success: true, redirect_to: root_path } }
      end
    else
      Rails.logger.debug "Failed login attempt for email: #{params[:email]}"
      
      respond_to do |format|
        format.html do
          flash.now[:alert] = "Invalid email or password"
          render :new, status: :unprocessable_entity
        end
        format.json do
          render json: { 
            success: false, 
            errors: ["Invalid email or password"]
          }, status: :unprocessable_entity
        end
      end
    end
  end
  
  def destroy
    current_user&.forget_me!
    cookies.delete(:remember_token)
    logout current_user
    redirect_to root_path, notice: "You have been logged out."
  end
end
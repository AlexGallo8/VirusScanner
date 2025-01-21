class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def new
  end
  
  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      login user
      
      respond_to do |format|
        format.html { redirect_to root_path, notice: "You have signed in successfully." }
        format.json { render json: { success: true, redirect_to: root_path } }
      end
    else
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
    logout current_user
    redirect_to root_path, notice: "You have been logged out."
  end
end
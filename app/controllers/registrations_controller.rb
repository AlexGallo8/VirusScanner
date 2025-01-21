class RegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    @user.auth_provider = 'local'
    @user.username = @user.email.split('@').first
    
    respond_to do |format|
      if @user.save
        login @user
        format.json { render json: { success: true, redirect_to: root_path } }
        format.html { redirect_to root_path, notice: "Successfully created account!" }
      else
        format.json { 
          render json: { 
            success: false, 
            errors: @user.errors.full_messages 
          }, status: :unprocessable_entity 
        }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
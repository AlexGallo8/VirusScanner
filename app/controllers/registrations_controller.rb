class RegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    @user.auth_provider = 'local'
    
    if @user.save
      login @user
      redirect_to root_path, notice: "Successfully created account!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end

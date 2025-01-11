class RegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      login @user
      redirect_to root_path, notice: "Successfully created account!"
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end

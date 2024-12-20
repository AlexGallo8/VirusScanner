class RegistrationsController < ApplicationController
  def new
    @user = User.new
    
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      login @user
      redirect_to root_path, notice: "Successfully created account!"
    else
      render(
        turbo_stream.create(
          "registration_form",
          partial: "registrations/form",
          locals: {
            user: @user
          }
        )
      )
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end

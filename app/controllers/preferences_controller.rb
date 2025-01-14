class PreferencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def edit
  end

  def update
    if password_update?
      handle_password_update
    else
      handle_profile_update
    end
  end

  private

  def set_user
    @user = current_user
  end

  def password_update?
    params[:user][:password].present?
  end

  def handle_password_update
    if @user.authenticate(params[:user][:current_password])
      if @user.update(password_params)
        redirect_to edit_preferences_path, notice: 'Password successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    else
      @user.errors.add(:current_password, 'is incorrect')
      render :edit, status: :unprocessable_entity
    end
  end

  def handle_profile_update
    if @user.update(profile_params)
      redirect_to edit_preferences_path, notice: 'Profile successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def profile_params
    params.require(:user).permit(:username)
  end
end
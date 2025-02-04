class PasswordResetsController < ApplicationController
    before_action :set_user_by_token, only: [:edit, :update]
    
    def new
    end

    def create
        if (user = User.find_by(email: params[:email]))
            token = user.generate_token_for(:password_reset)
            user.save  # Save to persist the token
            PasswordMailer.with(
                user: user,
                token: token
            ).password_reset.deliver_later
        end

        redirect_to root_path, notice: "Check your email to reset your password."
    end

    def edit
    end

    def update
        if @user.update(password_params)
            @user.update(password_reset_token: nil)  # Clear the token after successful reset
            redirect_to root_path, notice: "Your password has been reset successfully. Please login."
        else
            render :edit
        end
    end

    private

    def set_user_by_token
        @user = User.find_by_token_for(:password_reset, params[:token])
        redirect_to new_password_reset_path, alert: "Invalid token, please try again." unless @user.present?
    end

    def password_params
        params.require(:user).permit(:password, :password_confirmation)
    end
end
class RegistrationsController < ApplicationController
  def create
    @user = User.new
    if @user.save
      redirect_to root_path, notice: "Successfully created account"
    else
      render :new
    end
  end
end

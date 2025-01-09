class DashboardsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    render json: session[:userinfo]
  end
end

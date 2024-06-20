class MainController < ApplicationController
  def index
    flash[:notice] = "Logged in successfully"
    flash[:alert] = "Invalid email or password"
    flash[:error] = "404 Not Found"
    # This is a controller action that renders the main page
    # The view for this action is located at app/views/main/index.html.erb
  end
end
# class ApplicationController < ActionController::Base
#     before_action :set_current_user
#     def set_current_user
#         Current.user = User.find_by(id: session[:user_id])
#     end
# end

# class ApplicationController < ActionController::Base
#     before_action :set_current_user
  
#     private
  
#     def set_current_user
#       if clerk_session
#         @current_user = Clerk::User.find(clerk_session["user_id"])
#       end
#     end
  
#     def clerk_session
#       request.headers['Authorization']&.split(' ')&.last
#     end
# end
  
  require "clerk/authenticatable"

  class ApplicationController < ActionController::Base
    include ApplicationHelper
    include Clerk::Authenticatable
  
    helper_method :current_user
  
    content_security_policy do |policy|
      policy.base_uri :self, -> { "https://#{clerk_frontend_api()}" }
    end
  
    def current_user
      @current_user ||= clerk_user
    end
  end
  
class DarkModeController < ApplicationController
    def toggle
        cookies[:dark_mode] = (cookies[:dark_mode] != "true").to_s
        
        respond_to do |format|
            format.js { render layout: false }
            format.html { redirect_back(fallback_location: root_path) }
        end
    end
end
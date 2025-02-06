class DarkModeController < ApplicationController
    def toggle
        # Explicitly convert to boolean and then back to string
        @is_dark = cookies[:dark_mode] != "true"
        cookies[:dark_mode] = @is_dark.to_s
        
        respond_to do |format|
            format.js { render layout: false }
            format.html { redirect_back(fallback_location: root_path) }
        end
    end
end
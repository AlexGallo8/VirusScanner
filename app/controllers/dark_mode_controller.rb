class DarkModeController < ApplicationController
    def toggle
        # Forza la conversione a boolean e poi di nuovo a stringa
        current_state = cookies[:dark_mode] == "true"
        @is_dark = !current_state
        
        # Imposta il cookie con un valore esplicito
        cookies[:dark_mode] = {
            value: @is_dark.to_s,
            path: "/",
            expires: 1.year.from_now
        }
        
        respond_to do |format|
            format.js { render layout: false }
            format.html { redirect_back(fallback_location: root_path) }
        end
    end
end
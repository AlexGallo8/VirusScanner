# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def create
    # Verifica se l'utente ha inviato un token di login
    # (Ad esempio, questo potrebbe arrivare da una richiesta con il token JWT)
    clerk_user = Clerk::SDK::User.login(params[:token])

    # Se il login ha successo, imposta l'ID dell'utente nella sessione
    session[:user_id] = clerk_user.id

    # Redirect alla dashboard
    redirect_to dashboard_path
  rescue Clerk::Errors::Unauthorized => e
    # Se c'è un errore di autenticazione, reindirizza al login
    redirect_to login_path, alert: 'Autenticazione fallita.'
  end

  def destroy
    clerk_session = Clerk::Session.find_by(user_id: current_user.id)
    clerk_session.destroy if clerk_session

    redirect_to root_path, notice: 'Logged out successfully'
  end

  # def destroy
  #   # Logout: rimuovi l'ID dell'utente dalla sessione
  #   session.delete(:user_id)
  #   redirect_to login_path
  # end
end

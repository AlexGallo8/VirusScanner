# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
    before_action :authenticate_user
  
    def index
      # La dashboard sarà visibile solo agli utenti autenticati.
      @user = @clerk_user
    end
  
    private
  
    def authenticate_user
      # Verifica se esiste un user_id nella sessione
      if session[:user_id]
        # Ottieni l'utente tramite Clerk SDK
        @clerk_user = Clerk::SDK::User.find(session[:user_id])
      else
        # Se non c'è un user_id nella sessione, fai il redirect al login
        redirect_to login_path, alert: 'Devi eseguire il login per accedere a questa pagina.'
      end
    rescue Clerk::Errors::Unauthorized => e
      # Gestisci l'errore nel caso in cui la sessione dell'utente non sia più valida
      redirect_to login_path, alert: 'Sessione scaduta o utente non valido.'
    end
  end
  
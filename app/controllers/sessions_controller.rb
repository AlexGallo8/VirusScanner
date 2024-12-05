# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:local_login, :local_signup]

  def local_login
    # Trova l'utente per email
    user = User.find_by(email: params[:email])

    # Verifica la password
    if user && user.authenticate(params[:password])
      # Genera un token JWT per Clerk
      clerk_token = generate_clerk_token(user)

      render json: { 
        message: 'Login successful', 
        clerk_token: clerk_token 
      }, status: :ok
    else
      render json: { 
        message: 'Invalid email or password' 
      }, status: :unauthorized
    end
  end

  def local_signup
    # Crea un nuovo utente
    user = User.new(
      email: params[:email],
      password: params[:password]
    )

    if user.save
      # Genera un token JWT per Clerk
      clerk_token = generate_clerk_token(user)

      render json: { 
        message: 'Signup successful', 
        clerk_token: clerk_token 
      }, status: :created
    else
      render json: { 
        message: user.errors.full_messages.join(', ') 
      }, status: :unprocessable_entity
    end
  end

  def destroy
    clerk_session = Clerk::Session.find_by(user_id: current_user.id)
    clerk_session.destroy if clerk_session

    redirect_to root_path, notice: 'Logged out successfully'
  end

  private

  def generate_clerk_token(user)
    # Genera un token JWT personalizzato per Clerk
    # IMPORTANTE: Usa una libreria come 'jwt' per generare il token
    # Questo è solo un esempio molto semplificato
    payload = {
      sub: user.id,
      email: user.email,
      exp: 1.hour.from_now.to_i
    }

    # Genera il token usando la chiave segreta di Clerk
    JWT.encode(payload, ENV['CLERK_SECRET_KEY'], 'HS256')
  end
end
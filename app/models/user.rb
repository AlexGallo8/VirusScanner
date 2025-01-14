class User < ApplicationRecord
    has_many :scans
    has_many :comments, dependent: :destroy
    has_secure_password
  
    validates :email,
              presence: true,
              uniqueness: true,
              format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
    normalizes :email, with: ->(email) {email.strip.downcase}

    validates :username, presence: true, uniqueness: true, 
              length: { minimum: 3, maximum: 30 }
            #   format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only contain letters, numbers, and underscores" }

    validates :auth_provider, inclusion: { in: ['local', 'auth0'] }, allow_nil: true
    validates :auth0_uid, uniqueness: true, allow_nil: true

    generates_token_for :password_reset, expires_in: 15.minutes do
        password_salt&.last(10)
    end

    generates_token_for :email_confirmation, expires_in: 24.hours do
        email
    end

    # Gestione Google Token
    def token_expired?
        google_token_expires_at.present? && google_token_expires_at < Time.current
    end

    def refresh_google_token!
        return unless google_refresh_token.present?
    
        client = OAuth2::Client.new(
            Rails.application.credentials.google[:client_id],
            Rails.application.credentials.google[:client_secret],
            authorize_url: 'https://accounts.google.com/o/oauth2/auth',
            token_url: 'https://accounts.google.com/o/oauth2/token'
        )

        access_token = OAuth2::AccessToken.new(client, google_token, {
            refresh_token: google_refresh_token,
            expires_at: google_token_expires_at.to_i
        }).refresh!

        update!(
            google_token: access_token.token,
            google_token_expires_at: Time.at(access_token.expires_at)
        )
    end
end
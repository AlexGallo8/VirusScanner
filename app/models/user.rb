class User < ApplicationRecord
    has_many :scan_users
    has_many :scans, through: :scan_users

    has_many :comments, dependent: :destroy
    has_secure_password
    validates :password, 
              format: { 
                with: /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}\z/,
                message: "must be at least 8 characters long and include: 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character"
              },
              if: -> { password.present? }

    has_secure_token :password_reset_token

    def generate_token_for(purpose)
      send("regenerate_#{purpose}_token")
      send("#{purpose}_token")
    end

    def self.find_by_token_for(purpose, token)
      find_by("#{purpose}_token": token)
    end

    validates :email,
              presence: true,
              uniqueness: true,
              format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
    normalizes :email, with: ->(email) {email.strip.downcase}

    validates :username, uniqueness: true
            #   length: { minimum: 3, maximum: 30 }
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
  private

  def generate_username
    return if username.present?
    base_username = email.split('@').first
    self.username = base_username
    counter = 1
    while User.exists?(username: self.username)
      self.username = "#{base_username}#{counter}"
      counter += 1
    end
  end

  before_validation :set_username, on: :create

  private

  def set_username
    return if username.present?
    self.username = email.split('@').first if email.present?
  end
end
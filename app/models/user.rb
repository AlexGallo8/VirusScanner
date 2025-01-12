class User < ApplicationRecord
    # has_many :scans
    has_secure_password
  
    validates :email,
              presence: true,
              uniqueness: true,
              format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
    normalizes :email, with: ->(email) {email.strip.downcase}

    validates :auth_provider, inclusion: { in: ['local', 'auth0'] }, allow_nil: true
    validates :auth0_uid, uniqueness: true, allow_nil: true

    generates_token_for :password_reset, expires_in: 15.minutes do
        password_salt&.last(10)
    end

    generates_token_for :email_confirmation, expires_in: 24.hours do
        email
    end
end
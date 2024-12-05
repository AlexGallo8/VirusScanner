class User < ApplicationRecord
    has_secure_password
  
    validates :email,
              presence: true,
              uniqueness: true,
              format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
    normalizes :email, with: ->(email) {email.strip.downcase}

    # generates_token_for
end
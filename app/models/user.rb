class User < ApplicationRecord
  has_many :scan_users, dependent: :destroy
  has_many :scans, through: :scan_users
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comment_votes, dependent: :destroy

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

  def remember_me!
    loop do
      self.remember_token = SecureRandom.urlsafe_base64
      break unless User.exists?(remember_token: remember_token)
    end
    self.remember_token_expires_at = 2.weeks.from_now
    save(validate: false)
  end

  def forget_me!
    self.remember_token = nil
    self.remember_token_expires_at = nil
    save(validate: false)
  end

  def remembered_and_valid?
    remember_token.present? && 
    remember_token_expires_at.present? && 
    Time.current < remember_token_expires_at
  end

  private

  def generate_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

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
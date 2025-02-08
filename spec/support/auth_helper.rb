module AuthHelper
  def sign_in(user)
    post session_path, params: { email: user.email, password: user.password }
  end

  def login_as(user, scope: nil)
    # Programmatic login without using the form
    post session_path, params: { email: user.email, password: user.password }
    follow_redirect! if response.redirect?
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :feature
  config.include AuthHelper, type: :request
  config.include Rails.application.routes.url_helpers
end
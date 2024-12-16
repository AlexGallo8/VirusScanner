ENV["CLERK_PUBLISHABLE_KEY"] ||= Rails.application.credentials.dig(:clerk, :publishable_key)
ENV["CLERK_SECRET_KEY"] ||= Rails.application.credentials.dig(:clerk, :secret_key)
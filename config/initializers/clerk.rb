# Clerk.configure do |config|
#     config.api_key = 'sk_test_MpkAwEVyGcEwYOliZShdFI8llHyln9UDbCMnpDAVX4'
#     # config.frontend_api = 'https://fair-gopher-54.clerk.accounts.dev'
#   end

# Clerk.configure do |c|
#     c.publishable_key = 'pk_test_ZmFpci1nb3BoZXItNTQuY2xlcmsuYWNjb3VudHMuZGV2JA'
#     c.api_key = `sk_test_MpkAwEVyGcEwYOliZShdFI8llHyln9UDbCMnpDAVX4` # if omitted: ENV["CLERK_SECRET_KEY"] - API calls will fail if unset
#     c.base_url = "https://api.clerk.com/v1/"
#     c.logger = Logger.new(STDOUT) # if omitted, no logging
#     c.middleware_cache_store = Rails.cache # if omitted: no caching
# end

ENV["CLERK_PUBLISHABLE_KEY"] ||= Rails.application.credentials.dig(:clerk, :publishable_key)
ENV["CLERK_SECRET_KEY"] ||= Rails.application.credentials.dig(:clerk, :secret_key)

# DEBUG
# puts "CLERK_PUBLISHABLE_KEY from initializer: #{ENV["CLERK_PUBLISHABLE_KEY"].inspect}"

# Rails.application.config.after_initialize do
#     puts "Clerk key from credentials: #{Rails.application.credentials.dig(:clerk, :publishable_key)}"
#     puts "Clerk key from ENV: #{ENV["CLERK_PUBLISHABLE_KEY"]}"
# end
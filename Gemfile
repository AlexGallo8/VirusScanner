source "https://rubygems.org"

ruby "2.7.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.6.4"

# Remove the duplicate test group that appears later in the file

gem 'pycall'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

gem "virustotal_api"

# http requests
gem 'multipart-post'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

gem 'json', '~> 2.6', '>= 2.6.3'

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
end

group :development do
  gem "web-console"
  gem 'letter_opener_web'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "rack-test"
  gem "rack", "~> 2.2.8"
  gem 'prawn'
end

gem "tailwindcss-rails", "~> 2.0"

gem 'omniauth'
gem 'omniauth-auth0', '~> 3.0'
gem 'omniauth-rails_csrf_protection', '~> 1.0' # prevents forged authentication requests


# gem 'net-http' -> già presente
gem 'faraday', '~> 2.7.12'
gem 'faraday-net_http', '~> 2.0'

gem "jwt", "~> 2.8"

gem 'google-api-client', '~> 0.53.0'
gem 'googleauth', '~> 1.2.0'
gem 'omniauth-google-oauth2'
gem "google-apis-drive_v3", "~> 0.37.0"

gem "rspec-rails", "~> 7.1", :groups => [:development, :test]

gem "factory_bot_rails", "~> 6.2.0", :groups => [:development, :test]
gem "faker", "~> 3.4", :groups => [:development, :test]
# Update the sassc-rails gem specification
gem 'sassc-rails', '~> 2.1.0'

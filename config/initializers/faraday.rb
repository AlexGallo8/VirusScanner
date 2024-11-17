require 'faraday'
require 'faraday/net_http'

Faraday.default_adapter = :net_http

# Configurazione specifica per Clerk (opzionale)
# Clerk.configure do |config|
#   config.faraday_adapter = :net_http
#   config.api_key = 'sk_test_MpkAwEVyGcEwYOliZShdFI8llHyln9UDbCMnpDAVX4'
# end
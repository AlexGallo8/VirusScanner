module VirusTotal
    class << self
      attr_accessor :api_key, :base_url
  
      def configure
        yield self
      end
    end
  
    # Configurazioni di default
    self.base_url = 'https://www.virustotal.com/api/v3'
    self.api_key = Rails.application.credentials.virustotal[:api_key]
end
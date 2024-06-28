class Scan < ApplicationRecord
    has_one_attached :file
    validates :file, presence: true

    def virustotal_report
        # Metodo per ottenere il report di VirusTotal
    end
end

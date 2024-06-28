class Scan < ApplicationRecord
    # Attributo virtuale per contenere i dati del file
    attr_accessor :file_data

    # Validazione presenza del campo file_data
    validates :file_data, presence: true

    # Validazione presenza del campo per memorizzare l'ID della scansione
    #validates :scan_id, presence: true, if: -> { file_data.present? }

    # Metodo per aggiornare scan_id
    def update_scan_id(new_scan_id)
        self.scan_id = new_scan_id
        save!
    end

    def virustotal_report
        return unless scan_id.present?

        service = VirusTotalService.new(self)
        service.fetch_report
    end

    # Metodo per salvare il file nel database 
    def save_file
        return unless file_data.present?

        # Salva il file nel database
        delf.file_data = Base64.encode64(file_data.read)
        self.save
    end
end

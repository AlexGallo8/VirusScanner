require_relative '../config/environment'

# Carica il file e crea un nuovo record Scan
# file_data = File.read('/Users/alessandromaone/Desktop/Università/LabASSI/ciao.txt')
# scan = Scan.new(file_data: file_data)
# scan.save!

file_path = '/Users/alessandromaone/Desktop/Università/LabASSI/ciao.txt'
scan = Scan.new(file_data: File.read(file_path))
scan.save!

# Scansione del file
# VirusTotalService.new(scan).scan_file
api_key = 'a6c3b798a66de219ec6db2efbeb70dfe4bdef9b7003edda4a38b1386883535b5'
service = VirusTotalService.new(api_key)

# Ottiene il report
# report = VirusTotalService.new(scan).fetch_report
# puts JSON.pretty_generate(report)

# Scansione del file
result = service.scan_file(file_path)

# Ottieni l'ID della risorsa del risultato della scansione
resource = result['resource']

# sleep(15)

report = service.fetch_report(resource)
puts JSON.pretty_generate(report)
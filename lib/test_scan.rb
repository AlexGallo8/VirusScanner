require_relative '../config/environment'

# Carica il file e crea un nuovo record Scan
file_data = File.read('/Users/alessandromaone/Desktop/Università/LabASSI/ciao.txt')
scan = Scan.new(file_data: file_data)
scan.save!

# Scansione del file
VirusTotalService.new(scan).scan_file

# Ottiene il report
report = VirusTotalService.new(scan).fetch_report
puts JSON.pretty_generate(report)
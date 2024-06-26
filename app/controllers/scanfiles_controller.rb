class ScanfilesController < ApplicationController
  def new
  end

  def create
  end

  def show
  end
end



# app/controllers/scans_controller.rb
class ScanfilesController < ApplicationController
  def new
  end

  def create
    file = params[:file]
    file_path = file.tempfile.path

    service = VirusTotalService.new(Rails.application.config.virus_total_api_key)
    response = service.scan_file(file_path)
    
    scan_id = response['scan_id']

    redirect_to scan_path(scan_id: scan_id)
  end

  def show
    scan_id = params[:scan_id]
    service = VirusTotalService.new(Rails.application.config.virus_total_api_key)
    response = service.fetch_report(scan_id)

    @report = response
  end
end

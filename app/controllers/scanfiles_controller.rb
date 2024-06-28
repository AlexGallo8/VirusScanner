
class ScanfilesController < ApplicationController
  def create
    @scan_file = Scanfile.new(scan_file_params)
    if @scan_file.save
      virus_total_service = VirusTotalService.new('4fe8a3a6a41b79ced5a55201e606fe074d93105ac1570b9f61395b7b8d16a1f6')
      response = virus_total_service.upload_file(@scan_file)
      @scan_file.update(scan_result: response)
      render json: @scan_file, status: :created
    else
      render json: @scan_file.errors, status: :unprocessable_entity
    end
  end

  def show
    @scan_file = Scanfile.find(params[:id])
    virus_total_service = VirusTotalService.new('4fe8a3a6a41b79ced5a55201e606fe074d93105ac1570b9f61395b7b8d16a1f6')
    response = virus_total_service.get_file_report(@scan_file)
    render json: response
  end

  private

  def scan_file_params
    params.require(:scan_file).permit(:filename, :file_path)
  end
end

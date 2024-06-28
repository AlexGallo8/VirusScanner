class ScansController < ApplicationController
  before_action :set_scan, only: %i[ show edit update destroy ]

  # GET /scans or /scans.json
  def index
    @scans = Scan.all
  end

  # GET /scans/1 or /scans/1.json

  def show
    @scan = Scan.find(params[:id])
    virus_total_service = VirusTotalService.new('4fe8a3a6a41b79ced5a55201e606fe074d93105ac1570b9f61395b7b8d16a1f6')
    response = virus_total_service.get_file_report(@scan)
    @scan.update(scan_result: response)
    render json: @scan
  end

  # GET /scans/new
  def new
    @scan = Scan.new
  end

  # GET /scans/1/edit
  def edit
  end

  # POST /scans or /scans.json
  
  
=begin  
  def create
    @scan = Scan.new(scan_params)

    respond_to do |format|
      if @scan.save
        format.html { redirect_to scan_url(@scan), notice: "Scan was successfully created." }
        format.json { render :show, status: :created, location: @scan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @scan.errors, status: :unprocessable_entity }
      end
    end
  end
=end
  def create
    @scan = Scan.new(scan_params)
    if @scan.save
      virus_total_service = VirusTotalService.new('4fe8a3a6a41b79ced5a55201e606fe074d93105ac1570b9f61395b7b8d16a1f6')
      response = virus_total_service.upload_file(@scan)
      @scan.update(scan_result: response)
      render json: @scan, status: :created
    else
      render json: @scan.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /scans/1 or /scans/1.json
  def update
    respond_to do |format|
      if @scan.update(scan_params)
        format.html { redirect_to scan_url(@scan), notice: "Scan was successfully updated." }
        format.json { render :show, status: :ok, location: @scan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @scan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scans/1 or /scans/1.json
  def destroy
    @scan.destroy!

    respond_to do |format|
      format.html { redirect_to scans_url, notice: "Scan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scan
      @scan = Scan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def scan_params
      params.require(:scan).permit(:file_name, :file_type, :hashcode, :file_size, :upload_date, :vote_up, :vote_down)
    end
end

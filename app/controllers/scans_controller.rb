require 'net/http'
require 'uri'
require 'json'

class ScansController < ApplicationController
  before_action :set_scan, only: %i[ show edit update destroy ]

  # GET /scans or /scans.json
  def index
    @scans = Scan.all
  end

  # GET /scans/1 or /scans/1.json
  def show
    @scan = Scan.find(params[:id])
  end

  # GET /scans/new
  def new
    @scan = Scan.new
  end

  # GET /scans/1/edit
  def edit
  end

  # POST /scans or /scans.json
  def create
    @scan = Scan.new(scan_params)
    if @scan.save
      @scan.save_file
      VirusTotal.new(@scan).scan_file
      redirect_to @scan, notice: 'File uploaded and scan initiated.'
    else
      render :new
    end
  end

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
      params.require(:scan).permit(:file_name, :file_type, :hashcode, :file_size, :upload_date, :vote_up, :vote_down, :file_data)
    end
end

class ScansController < ApplicationController
  before_action :set_scan, only: %i[ show edit update destroy upvote downvote ]
  before_action :authenticate_user!, only: [:upvote, :downvote]

  # GET /scans or /scans.json
  def index
    @scans = current_user.scans.order(upload_date: :desc)
  end

  # GET /scans/1 or /scans/1.json

  def show
    @scan = Scan.find(params[:id])
  
    # Only fetch new results if we don't have them already
    if @scan.scan_result.blank? && @scan.vt_id.present?
      virus_total_service = VirusTotalService.new('4fe8a3a6a41b79ced5a55201e606fe074d93105ac1570b9f61395b7b8d16a1f6')
      response = virus_total_service.get_file_report(@scan)
      @scan.update(scan_result: response)
    end
  
    @results = @scan.scan_result
  
    # Calculate statistics from scan_result
    if @results.present? && @results['data'].present? && @results['data']['attributes'].present?
      stats = @results['data']['attributes']['stats']
      @malicious_count = stats['malicious'] || 0
      @undetected_count = stats['undetected'] || 0
      @total = @results['data']['attributes']['results']&.size || 0
    else
      @malicious_count = 0
      @undetected_count = 0
      @total = 0
    end
  
    respond_to do |format|
      format.html
      format.json { render json: @scan }
    end
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

  def upvote
    vote = @scan.votes.find_or_initialize_by(user: current_user)
    
    if vote.new_record? || vote.vote_type != 'up'
      Vote.transaction do
        if vote.persisted?
          @scan.decrement!("vote_#{vote.vote_type}") if vote.vote_type.present?
        end
        vote.update!(vote_type: 'up')
        @scan.increment!(:vote_up)
      end
      message = "Voto positivo registrato!"
    else
      message = "Hai già votato questo file!"
    end

    respond_to do |format|
      format.html { redirect_to @scan, notice: message }
      format.json { render json: { votes: { up: @scan.vote_up, down: @scan.vote_down } } }
    end
  end

  def downvote
    vote = @scan.votes.find_or_initialize_by(user: current_user)
    
    if vote.new_record? || vote.vote_type != 'down'
      Vote.transaction do
        if vote.persisted?
          @scan.decrement!("vote_#{vote.vote_type}") if vote.vote_type.present?
        end
        vote.update!(vote_type: 'down')
        @scan.increment!(:vote_down)
      end
      message = "Voto negativo registrato!"
    else
      message = "Hai già votato questo file!"
    end

    respond_to do |format|
      format.html { redirect_to @scan, notice: message }
      format.json { render json: { votes: { up: @scan.vote_up, down: @scan.vote_down } } }
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

class VirusTotalController < ApplicationController
  require 'net/http'
  require 'json'
  require 'uri'
  require 'digest'

  API_KEY = Rails.application.credentials.virustotal[:api_key]
  BASE_URL = 'https://www.virustotal.com/api/v3'
  
  def index
  end
 
  def scan
    respond_to do |format|
      format.html do
        if params[:scan_id].present?
          @scan = Scan.find_by(id: params[:scan_id])
          @results = @scan&.scan_result
          render :scan
        else
          process_scan
        end
      end
      
      format.json do
        if params[:check_status].present?
          @scan = Scan.find_by(id: params[:scan_id])
          render json: { 
            status: @scan&.scan_result.present? ? 'completed' : 'processing',
            results: @scan&.scan_result
          }
        else
          process_scan
          render json: { 
            status: 'processing',
            scan_id: @scan&.id
          }
        end
      end
    end
  end

  private

  def process_scan
    if params[:file].present?
      process_file_scan
    elsif params[:url].present?
      process_url_scan
    else
      flash[:alert] = "Per favore, seleziona un file da scansionare o inserisci un URL"
      redirect_to virus_total_path
    end
  end

  def process_file_scan
    file = params[:file]
    file_hash = calculate_file_hash(file.tempfile)
    
    # Check if we already have a scan for this file
    @scan = Scan.find_by(hashcode: file_hash)
    
    if @scan
      # Associa l'utente corrente se è loggato e la scansione non ha già un utente
      if user_signed_in? && @scan.user_id.nil?
        @scan.update(user_id: current_user.id)
      end
      
      # If scan exists but doesn't have results yet, we need to check status
      if @scan.scan_result.blank?
        vt_results = get_analysis_result(@scan.file_data['scan_id'])
        @scan.update(scan_result: vt_results) if vt_results.present?
      end
    else
      # Create new scan record
      @scan = create_scan(
        file_name: file.original_filename,
        file_type: file.content_type,
        file_size: file.size,
        hashcode: file_hash,
        upload_date: Time.current
      )
      
      # Upload to VirusTotal and store scan_id
      vt_scan_id = upload_file(file.tempfile.path)
      @scan.update(file_data: { scan_id: vt_scan_id })
      
      # If it's a regular form submission, wait for results
      if request.format.html?
        wait_for_results
      end
    end
    
    render :scan if request.format.html?
  end

  def process_url_scan
    url = params[:url]
    url_hash = Digest::SHA256.hexdigest(url)
    
    # Check if we already have a scan for this URL
    @scan = Scan.find_by(hashcode: url_hash)
    
    if @scan
      # Associa l'utente corrente se è loggato e la scansione non ha già un utente
      if user_signed_in? && @scan.user_id.nil?
        @scan.update(user_id: current_user.id)
      end
      
      if @scan.scan_result.blank?
        vt_results = get_analysis_result(@scan.file_data['scan_id'])
        @scan.update(scan_result: vt_results) if vt_results.present?
      end
    else
      # Create new scan record
      @scan = create_scan(
        file_name: url,
        file_type: 'url',
        hashcode: url_hash,
        upload_date: Time.current
      )
      
      # Submit to VirusTotal and store scan_id
      vt_scan_id = submit_url(url)
      @scan.update(file_data: { scan_id: vt_scan_id })
      
      # If it's a regular form submission, wait for results
      if request.format.html?
        wait_for_results
      end
    end
    
    render :scan if request.format.html?
  end

  def wait_for_results
    max_attempts = 30
    attempt = 0
    
    while attempt < max_attempts
      vt_results = get_analysis_result(@scan.file_data['scan_id'])
      if vt_results.present? && vt_results.size > 0
        @scan.update(scan_result: vt_results)
        break
      end
      sleep 2
      attempt += 1
    end
    
    if attempt >= max_attempts
      flash[:alert] = "L'analisi sta richiedendo più tempo del previsto. Riprova più tardi."
      redirect_to virus_total_path
    end
  end

  def calculate_file_hash(file)
    Digest::SHA256.file(file).hexdigest
  end

  def create_scan(attributes)
    if user_signed_in?
      Scan.create!(attributes.merge(user_id: current_user.id))
    else
      Scan.create!(attributes)  # user_id will be nil
    end
  end

  def upload_file(file_path)
    url = URI("#{BASE_URL}/files")
    
    request = Net::HTTP::Post.new(url)
    request["accept"] = 'application/json'
    request["x-apikey"] = API_KEY
    
    form_data = [['file', File.open(file_path)]]
    request.set_form form_data, 'multipart/form-data'
    
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end
    
    JSON.parse(response.body)['data']['id']
  end

  def submit_url(url)
    api_url = URI("#{BASE_URL}/urls")
    
    request = Net::HTTP::Post.new(api_url)
    request["accept"] = 'application/json'
    request["x-apikey"] = API_KEY
    request["content-type"] = 'application/x-www-form-urlencoded'
    request.body = "url=#{URI.encode_www_form_component(url)}"
    
    response = Net::HTTP.start(api_url.hostname, api_url.port, use_ssl: true) do |http|
      http.request(request)
    end
    
    JSON.parse(response.body)['data']['id']
  end

  def get_analysis_result(file_id)
    url = URI("#{BASE_URL}/analyses/#{file_id}")
    
    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["x-apikey"] = API_KEY
    
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end
    
    JSON.parse(response.body)['data']['attributes']['results']
  end
end
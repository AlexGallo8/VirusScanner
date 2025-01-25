class VirusTotalController < ApplicationController
  require 'net/http'
  require 'json'
  require 'uri'
  require 'digest'  # Add this at the top with other requires

  API_KEY = '4fe8a3a6a41b79ced5a55201e606fe074d93105ac1570b9f61395b7b8d16a1f6'
  BASE_URL = 'https://www.virustotal.com/api/v3'

  def index
  end
 
  def scan
    respond_to do |format|
      format.html do
        if params[:scan_id].present?
          Rails.logger.info "Fetching results for scan_id: #{params[:scan_id]}"
          # Check if scan exists in database first
          existing_scan = Scan.find_by(vt_id: params[:scan_id])
          if existing_scan&.scan_result.present?
            @results = existing_scan.scan_result
            Rails.logger.info "Retrieved results from database: #{@results}"
          else
            @results = get_analysis_result(params[:scan_id])
            Rails.logger.info "Retrieved results from API: #{@results}"
          end
          @scan_id = params[:scan_id]
          render :scan
        else
          handle_scan_request
          Rails.logger.info "Scan request handled, results: #{@results}"
          Rails.logger.info "Scan ID being used: #{@scan_id}"
          render :scan
        end
      end
      
      format.json do
        if params[:check_status].present? && params[:scan_id].present?
          # Check database first for existing results
          existing_scan = Scan.find_by(vt_id: params[:scan_id])
          @results = if existing_scan&.scan_result.present?
            existing_scan.scan_result
          else
            get_analysis_result(params[:scan_id])
          end
          
          render json: { 
            status: @results.present? ? 'completed' : 'processing',
            results: @results,
            scan_id: params[:scan_id]
          } and return
        else
          handle_scan_request
          render json: { 
            status: @results.present? ? 'completed' : 'processing',
            scan_id: @scan_id,
            results: @results
          }
        end
      end
    end
  end

  # Move this above the private keyword
  def handle_scan_request
    if params[:file].present?
      process_file_scan
    elsif params[:url].present?
      process_url_scan
    else
      flash[:alert] = "Per favore, seleziona un file da scansionare o inserisci un URL"
      redirect_to virus_total_path
    end
  end

  private

  def calculate_file_hash(file_path)
    Digest::SHA256.file(file_path).hexdigest
  end

  # Remove the process_scan method since we've replaced it with handle_scan_request
  def process_file_scan
    file_path = params[:file].tempfile.path
    file_hash = calculate_file_hash(file_path)

    existing_scan = Scan.find_by(hashcode: file_hash)

    if existing_scan
      if user_signed_in? && existing_scan.user_id.nil?
        existing_scan.update(user_id: current_user.id)
      end

      @results = existing_scan.scan_result
      @scan_id = existing_scan.vt_id
    else
      @scan_id = upload_file(file_path)
      
      session[:current_scan_id] = @scan_id
      
      scan = Scan.create(
        file_name: params[:file].original_filename,
        file_type: params[:file].content_type,
        hashcode: file_hash,
        file_size: File.size(file_path),
        upload_date: Time.current,
        user_id: current_user&.id,
        vt_id: @scan_id,
        scan_result: nil
      )

      @results = wait_for_results

      if @results.present?
        scan.update(scan_result: @results)
        Rails.logger.info "Scan results for #{scan.file_name}: #{@results}"
      end
    end
  end

  def process_url_scan
    url = params[:url]
    
    existing_scan = Scan.find_by(file_name: url)

    if existing_scan
      if user_signed_in? && existing_scan.user_id.nil?
        existing_scan.update(user_id: current_user.id)
      end

      @results = existing_scan.scan_result
      @scan_id = existing_scan.vt_id  # Change this line
    else
      @scan_id = submit_url(url)
      
      session[:current_scan_id] = @scan_id

      scan = Scan.create(
        file_name: url,
        file_type: 'url',
        hashcode: Digest::SHA256.hexdigest(url),
        upload_date: Time.current,
        user_id: current_user&.id,
        vt_id: @scan_id,  # Add this line
        scan_result: nil
      )

      results = wait_for_results

      scan.update(scan_result: results)
      @results = results
    end
  end

  def wait_for_results
    max_attempts = 30  # Maximum number of attempts
    attempt = 0
    
    while attempt < max_attempts
      @results = get_analysis_result(@scan_id)
      break if @results.present? && @results.any?
      sleep 2  # Wait 2 seconds between attempts
      attempt += 1
    end
    
    if attempt >= max_attempts
      flash[:alert] = "L'analisi sta richiedendo più tempo del previsto. Riprova più tardi."
      redirect_to virus_total_path
    end

    # Questo fa salvare correttamente in scan_result
    @results
  end

  def check_scan_status
    scan_id = session[:current_scan_id]
    return unless scan_id
    
    results = get_analysis_result(scan_id)
    
    if results.present? && results.size > 0
      @results = results
      session.delete(:current_scan_id)
      true
    else
      false
    end
  end

  # Your existing helper methods remain the same
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
    
    parsed_response = JSON.parse(response.body)
    Rails.logger.info "Raw API Response for #{file_id}: #{parsed_response}"
    
    return nil unless parsed_response['data'] && 
                     parsed_response['data']['attributes']

    attributes = parsed_response['data']['attributes']
    
    {
      'stats' => attributes['stats'],
      'results' => attributes['results'].transform_values do |vendor_result|
        {
          'category' => vendor_result['category'],
          'result' => vendor_result['result']
        }
      end
    }
  end

  def wait_for_results
    max_attempts = 30
    attempt = 0
    
    while attempt < max_attempts
      current_results = get_analysis_result(@scan_id)
      
      if current_results.present? && current_results.any?
        @results = current_results
        Rails.logger.info "Results found after #{attempt} attempts: #{@results}"
        break
      end
      
      sleep 2
      attempt += 1
    end
    
    if attempt >= max_attempts
      flash[:alert] = "L'analisi sta richiedendo più tempo del previsto. Riprova più tardi."
      redirect_to virus_total_path and return
    end

    @results
  end
end


# FUNZIONI PROVA UPLOAD VIA DRIVE
  # def pick_from_drive
  #   client = Google::Apis::DriveV3::DriveService.new
  #   client.authorization = current_user.google_token

  #   @files = client.list_files(
  #     q: "mimeType != 'application/vnd.google-apps.folder'",
  #     fields: 'files(id, name, mimeType)',
  #     page_size: 50
  #   )
    
  #   render partial: 'drive_picker'
  # end

  # def download_from_drive
  #   file_id = params[:file_id]
    
  #   client = Google::Apis::DriveV3::DriveService.new
  #   client.authorization = current_user.google_token
    
  #   file = client.get_file(file_id, download_dest: StringIO.new)
    
  #   # Create a temporary file
  #   temp_file = Tempfile.new([params[:file_name], File.extname(params[:file_name])])
  #   temp_file.binmode
  #   temp_file.write(file.string)
  #   temp_file.rewind
    
  #   # Process the file with your existing virus scan logic
  #   scan_result = scan_file(temp_file)
    
  #   temp_file.close
  #   temp_file.unlink
    
  #   render json: scan_result
  # end
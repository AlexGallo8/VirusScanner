class VirusTotalController < ApplicationController
  require 'net/http'
  require 'json'
  require 'uri'
  require 'digest'  # Add this at the top with other requires

  BASE_URL = 'https://www.virustotal.com/api/v3'

  def index
    respond_to do |format|
      format.html
      format.json { render json: { status: 'ok' } }
    end
  end
 
  def scan
    respond_to do |format|
      format.html do
        Rails.logger.info "Starting HTML format scan with params: #{params.inspect}"
        if params[:scan_id].present?
          Rails.logger.info "Fetching results for scan_id: #{params[:scan_id]}"
          @scan = Scan.find_by(vt_id: params[:scan_id])
          
          if @scan&.scan_result.present?
            Rails.logger.info "Found existing scan with results"
            redirect_to scan_path(@scan) and return
          else
            Rails.logger.info "No existing scan found or no results, fetching from API"
            @results = get_analysis_result(params[:scan_id])
            redirect_to scan_path(@scan) if @scan
          end
        else
          Rails.logger.info "No scan_id present, handling new scan request"
          handle_scan_request
          redirect_to scan_path(@scan) if @scan&.persisted?
        end
      end
      
      format.json do
        if params[:check_status].present? && params[:scan_id].present?
          # Don't process if scan_id is undefined or invalid
          if params[:scan_id] == 'undefined' || params[:scan_id].blank?
            render json: { 
              status: 'error',
              message: 'Invalid scan ID'
            }, status: :bad_request
            return
          end

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
          }
        else
          handle_scan_request
          render json: { 
            status: @results.present? ? 'completed' : 'processing',
            scan_id: @scan_id,
            results: @results
          } unless performed?
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
      redirect_to virus_total_path and return
    end
  end

  # User-story: get a summary of all behaviour reports for a file
  def get_behavior_analysis
    scan_id = params[:id]
    Rails.logger.info "Fetching behavior analysis for scan_id: #{scan_id}"
    
    scan = Scan.find_by(vt_id: scan_id)
    
    if scan
      if scan.file_type.to_s.downcase == 'url' || scan.file_type.to_s.downcase.include?('url')
        render json: {
          status: 'not_supported',
          message: 'L\'analisi comportamentale è disponibile solo per i file, non per gli URL.',
          file_type: scan.file_type,
          file_name: scan.file_name
        }
        return
      end
    
      url = URI("#{BASE_URL}/files/#{scan.hashcode}/behaviour_summary")
      Rails.logger.info "Requesting behavior analysis for hash: #{scan.hashcode}"
      
      request = Net::HTTP::Get.new(url)
      request["accept"] = 'application/json'
      request["x-apikey"] = api_key
      
      response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
        http.request(request)
      end
      
      Rails.logger.info "VirusTotal API Response Status: #{response.code}"
      Rails.logger.info "VirusTotal API Response Body: #{response.body}"
      
      parsed_response = JSON.parse(response.body)
      
      if response.code == "200" && parsed_response["data"].nil?
        render json: {
          status: 'no_data',
          message: 'Analisi comportamentale non disponibile per questo file. ' \
                  'Questo può accadere se il file non è un eseguibile o se l\'analisi è ancora in corso.',
          file_type: scan.file_type,
          file_name: scan.file_name
        }
      else
        render json: parsed_response
      end
    else
      render json: { error: 'Scan not found' }, status: :not_found
    end
  end

  private

  def api_key
    Rails.application.credentials.virustotal[:api_key]
  end

  def calculate_file_hash(file_path)
    Digest::SHA256.file(file_path).hexdigest
  end

  # Remove the process_scan method since we've replaced it with handle_scan_request
  def process_file_scan
    begin
      file_path = params[:file].tempfile.path
      file_hash = calculate_file_hash(file_path)
    
      existing_scan = Scan.find_by(hashcode: file_hash)
    
      if existing_scan
        if user_signed_in?
          existing_scan.users << current_user unless existing_scan.users.include?(current_user)
          existing_scan.update(user_id: current_user.id) if existing_scan.user_id.nil?
        end
    
        @results = existing_scan.scan_result
        @scan_id = existing_scan.vt_id
        @scan = existing_scan
      else
        @scan_id = if params[:upload_type] == 'larger'
                     upload_larger_file(file_path)
                   else
                     upload_file(file_path)
                   end
      
        session[:current_scan_id] = @scan_id
        
        @scan = Scan.create!(  # Cambia da 'scan' a '@scan'
          file_name: params[:file].original_filename,
          file_type: params[:file].content_type,
          hashcode: file_hash,
          file_size: File.size(file_path),
          upload_date: Time.current,
          user_id: current_user&.id,
          vt_id: @scan_id,
          scan_result: nil
        )

        if user_signed_in?
          @scan.users << current_user unless @scan.users.include?(current_user)
        end
    
        @results = wait_for_results
        if @results.present?
          @scan.update!(scan_result: @results)
          Rails.logger.info "Scan results for #{@scan.file_name}: #{@results}"
        else
          flash.now[:alert] = "Impossibile completare la scansione. Riprova più tardi."
        end
      end
    rescue StandardError => e
      Rails.logger.error "Error in process_file_scan: #{e.message}"
      flash.now[:error] = "Si è verificato un errore durante la scansione del file."
      @results = nil
    end
  end

  def process_url_scan
    url = params[:url]
    
    existing_scan = Scan.find_by(file_name: url)

    if existing_scan
      if user_signed_in?
        existing_scan.users << current_user unless existing_scan.users.include?(current_user)
        existing_scan.update(user_id: current_user.id) if existing_scan.user_id.nil?
      end

      @results = existing_scan.scan_result
      @scan_id = existing_scan.vt_id
      @scan = existing_scan  # Aggiungi questa riga
    else
      @scan_id = submit_url(url)
      
      session[:current_scan_id] = @scan_id

      @scan = Scan.create(  # Assegna il risultato a @scan
        file_name: url,
        file_type: 'url',
        hashcode: Digest::SHA256.hexdigest(url),
        upload_date: Time.current,
        user_id: current_user&.id,
        vt_id: @scan_id,
        scan_result: nil
      )

      if user_signed_in?
        @scan.users << current_user unless @scan.users.include?(current_user)
      end

      @results = wait_for_results
      if @results.present?
        @scan.update(scan_result: @results)
      else
        flash.now[:alert] = "Impossibile completare la scansione. Riprova più tardi."
      end
    end
  end

  def wait_for_results
    max_attempts = 60  # Aumentato da 30 a 60 tentativi
    attempt = 0
    
    while attempt < max_attempts
      response = get_analysis_result(@scan_id)
      
      if response && response['status']
        case response['status']
        when 'completed'
          if response['results'].present? && response['results'].any?
            @results = response['results']
            Rails.logger.info "Results found after #{attempt} attempts: #{@results}"
            return @results
          end
        when 'queued'
          Rails.logger.info "Scan still queued (attempt #{attempt + 1})"
          sleep 5  # Aumentato da 2 a 5 secondi per file in coda
          attempt += 1
        when 'in-progress'
          Rails.logger.info "Scan in progress (attempt #{attempt + 1})"
          sleep 3  # Attesa di 3 secondi per file in elaborazione
          attempt += 1
        else
          Rails.logger.error "Unexpected scan status: #{response['status']}"
          break
        end
      else
        Rails.logger.error "Invalid response format or missing status"
        sleep 3
        attempt += 1
      end
    end
    
    # Salva comunque lo stato corrente anche se non è completato
    if response && response['status']
      @scan.update(scan_status: response['status']) if @scan
    end
    
    flash.now[:alert] = "L'analisi sta richiedendo più tempo del previsto. Puoi controllare lo stato della scansione più tardi nella tua dashboard."
    nil
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
  # Update upload_file method
  def upload_file(file_path)
    url = URI("#{BASE_URL}/files")
    
    request = Net::HTTP::Post.new(url)
    request["accept"] = 'application/json'
    request["x-apikey"] = api_key   # Changed from API_KEY
    
    form_data = [['file', File.open(file_path)]]
    request.set_form form_data, 'multipart/form-data'
    
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end
    
    JSON.parse(response.body)['data']['id']
  end
  
  def upload_larger_file(file_path)
    # First, get the upload URL
    url = URI("#{BASE_URL}/files/upload_url")
    
    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["x-apikey"] = api_key   # Changed from API_KEY
    
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end
    
    parsed_response = JSON.parse(response.body)
    Rails.logger.info "Upload URL Response: #{parsed_response}"
    
    upload_url = parsed_response['data']
    upload_uri = URI(upload_url)
    
    # Then, upload the file to the provided URL
    upload_request = Net::HTTP::Post.new(upload_uri)
    upload_request["accept"] = 'application/json'
    upload_request["x-apikey"] = api_key
    
    file = File.open(file_path)
    form_data = [['file', file]]
    upload_request.set_form(form_data, 'multipart/form-data')
    
    upload_response = Net::HTTP.start(upload_uri.hostname, upload_uri.port, use_ssl: true) do |http|
      http.request(upload_request)
    end
    
    Rails.logger.info "Upload Response: #{upload_response.body}"
    
    # Parse the response and get the analysis ID
    parsed_upload = JSON.parse(upload_response.body)
    if parsed_upload && parsed_upload['data'] && parsed_upload['data']['id']
      parsed_upload['data']['id']
    else
      raise "Failed to get analysis ID from response: #{upload_response.body}"
    end
  ensure
    file&.close if defined?(file)
  end

  def submit_url(url)
    api_url = URI("#{BASE_URL}/urls")
    
    request = Net::HTTP::Post.new(api_url)
    request["accept"] = 'application/json'
    request["x-apikey"] = api_key
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
    request["x-apikey"] = api_key
    
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end
    
    parsed_response = JSON.parse(response.body)
    Rails.logger.info "Raw API Response for #{file_id}: #{parsed_response}"
    
    return nil unless parsed_response['data'] && 
                     parsed_response['data']['attributes']

    attributes = parsed_response['data']['attributes']
    
    if attributes['status'] == 'completed' && attributes['results'].present?
      # When completed, return both status and results
      {
        'status' => attributes['status'],
        'results' => attributes['results'].transform_values do |vendor_result|
          {
            'category' => vendor_result['category'],
            'result' => vendor_result['result'],
            'method' => vendor_result['method'],
            'engine_name' => vendor_result['engine_name'],
            'engine_version' => vendor_result['engine_version']
          }
        end
      }
    else
      # For non-completed states, return the attributes
      attributes
    end
  end

  def wait_for_results
    max_attempts = 60
    attempt = 0
    
    while attempt < max_attempts
      response = get_analysis_result(@scan_id)
      
      if response && response['status']
        case response['status']
        when 'completed'
          if response['results'].present?
            @results = response['results']
            Rails.logger.info "Results found after #{attempt} attempts: #{@results}"
            return @results
          end
        when 'queued'
          Rails.logger.info "Scan still queued (attempt #{attempt + 1})"
          sleep 5
          attempt += 1
        when 'in-progress'
          Rails.logger.info "Scan in progress (attempt #{attempt + 1})"
          sleep 3
          attempt += 1
        else
          Rails.logger.error "Unexpected scan status: #{response['status']}"
          break
        end
      else
        Rails.logger.error "Invalid response format or missing status: #{response.inspect}"
        sleep 3
        attempt += 1
      end
    end
    
    # Salva comunque lo stato corrente anche se non è completato
    if response && response['status']
      @scan.update(scan_status: response['status']) if @scan
    end
    
    flash.now[:alert] = "L'analisi sta richiedendo più tempo del previsto. Riprova più tardi."
    nil
  end
end
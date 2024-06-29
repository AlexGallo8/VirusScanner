# app/controllers/virus_total_controller.rb
class VirusTotalController < ApplicationController
  require 'net/http'
  require 'json'
  require 'uri'

  API_KEY = '4fe8a3a6a41b79ced5a55201e606fe074d93105ac1570b9f61395b7b8d16a1f6'
  BASE_URL = 'https://www.virustotal.com/api/v3'

  def index
  end

  def scan
    if params[:file].present?
      file_path = params[:file].tempfile.path
      file_id = upload_file(file_path)
      sleep(5) until get_analysis_result(file_id).size > 0
      @results = get_analysis_result(file_id)
    elsif params[:url].present?
      scan_url
    else
      flash[:alert] = "Per favore, seleziona un file da scansionare o inserisci un URL"
      redirect_to virus_total_path
    end
  end

  private

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

  def scan_url
    url = params[:url]
    url_id = submit_url(url)
    sleep 15 # Attendi 15 secondi prima di controllare i risultati
    @results = get_analysis_result(url_id)
    render :scan
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
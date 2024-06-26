# app/services/virus_total_service.rb
require 'net/http'
require 'uri'
require 'json'

class VirusTotalService
  BASE_URI = 'https://www.virustotal.com/vtapi/v2'.freeze

  def initialize(api_key)
    @api_key = api_key
  end

  def scan_file(file_path)
    uri = URI.parse("#{BASE_URI}/file/scan")
    request = Net::HTTP::Post::Multipart.new uri.path,
      'apikey' => @api_key,
      'file' => UploadIO.new(File.new(file_path), "application/octet-stream", File.basename(file_path))

    send_request(uri, request)
  end

  def fetch_report(resource)
    uri = URI.parse("#{BASE_URI}/file/report?apikey=#{@api_key}&resource=#{resource}")
    request = Net::HTTP::Get.new(uri)

    send_request(uri, request)
  end

  private

  def send_request(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(request)

    JSON.parse(response.body)
  end
end

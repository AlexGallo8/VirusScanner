# # app/services/virus_total_service.rb
# require 'net/http'
# require 'uri'
# require 'json'

# class VirusTotalService
#   BASE_URI = 'https://www.virustotal.com/vtapi/v2'.freeze

#   def initialize(api_key)
#     @api_key = api_key
#   end

#   def scan_file(file_path)
#     uri = URI.parse("#{BASE_URI}/file/scan")
#     request = Net::HTTP::Post::Multipart.new uri.path,
#       'apikey' => @api_key,
#       'file' => UploadIO.new(File.new(file_path), "application/octet-stream", File.basename(file_path))

#     send_request(uri, request)
#   end

#   def fetch_report(resource)
#     uri = URI.parse("#{BASE_URI}/file/report?apikey=#{@api_key}&resource=#{resource}")
#     request = Net::HTTP::Get.new(uri)

#     send_request(uri, request)
#   end

#   private

#   def send_request(uri, request)
#     http = Net::HTTP.new(uri.host, uri.port)
#     http.use_ssl = true
#     response = http.request(request)

#     JSON.parse(response.body)
#   end
# end


class VirusTotalService
  def initialize(scan)
    @scan = scan
    @api_key = 'a6c3b798a66de219ec6db2efbeb70dfe4bdef9b7003edda4a38b1386883535b5'
  end

  def scan_file
    file_data_decoded = Base64.decode64(@scan.file_data)

    uri = URI.parse("https://www.virustotal.com/api/v3/files")
    request = Net::HTTP::Post.new(uri)
    request["x-apikey"] = @api_key


    #####################################

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["accept"] = 'application/json'
    request["x-apikey"] = 'a6c3b798a66de219ec6db2efbeb70dfe4bdef9b7003edda4a38b1386883535b5'
    request["content-type"] = 'multipart/form-data; boundary=---011000010111000001101001'
    request.body = "-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"file\"; filename=\"ruby_intro.rb\"\r\nContent-Type: text/x-ruby-script\r\n\r\ndata:text/x-ruby-script;name=ruby_intro.rb;base64,IyBXaGVuIGRvbmUsIHN1Ym1pdCB0aGlzIGVudGlyZSBmaWxlIHRvIHRoZSBhdXRvZ3JhZGVyLgoKIyBQYXJ0IDEKCmRlZiBzdW0gYXJyCiAgI0RlZmluZSBhIG1ldGhvZCBgc3VtKGFycmF5KWAgdGhhdCB0YWtlcyBhbiBhcnJheSBvZiBpbnRlZ2VycyBhcyBhbiBhcmd1bWVudCBhbmQgcmV0dXJucyB0aGUgc3VtIG9mIGl0cyBlbGVtZW50cy4gRm9yIGFuIGVtcHR5IGFycmF5IGl0IHNob3VsZCByZXR1cm4gemVyby4gIAogICNSdW4gYXNzb2NpYXRlZCB0ZXN0cyB2aWE6ICBgJCByc3BlYyAtZSAnI3N1bSAnIHNwZWMvcGFydDFfc3BlYy5yYmAKICAjIFlPVVIgQ09ERSBIRVJFCiAgc3VtID0gMAogIGlmIGFyci5sZW5ndGggPT0gMAogICAgcmV0dXJuIHN1bQogIGVsc2UKICAgIGFyci5lYWNoIGRvIHxpfAogICAgICBzdW0gKz0gaQogICAgZW5kCiAgICByZXR1cm4gc3VtCiAgZW5kCmVuZAoKZGVmIG1heF8yX3N1bSBhcnIKICAjRGVmaW5lIGEgbWV0aG9kIGBtYXhfMl9zdW0oYXJyYXkpYCB3aGljaCB0YWtlcyBhbiBhcnJheSBvZiBpbnRlZ2VycyBhcyBhbiBhcmd1bWVudCBhbmQgcmV0dXJucyB0aGUgc3VtIG9mIGl0cyB0d28gbGFyZ2VzdCBlbGVtZW50cy4gRm9yIGFuIGVtcHR5IGFycmF5IGl0IHNob3VsZCByZXR1cm4gemVyby4gRm9yIGFuIGFycmF5IHdpdGgganVzdCBvbmUgZWxlbWVudCwgaXQgc2hvdWxkIHJldHVybiB0aGF0IGVsZW1lbnQgKENvbnNpZGVyIGlmIHRoZSB0d28gbGFyZ2VzdCBlbGVtZW50cyBhcmUgdGhlIHNhbWUgdmFsdWUgYXMgd2VsbCkuIAogICNSdW4gYXNzb2NpYXRlZCB0ZXN0cyB2aWE6ICBgJCByc3BlYyAtZSAnI21heF8yX3N1bScgc3BlYy9wYXJ0MV9zcGVjLnJiYAogICMgWU9VUiBDT0RFIEhFUkUKICBpZiBhcnIubGVuZ3RoID09IDAKICAgIHJldHVybiAwCgogIGVsc2lmIGFyci5sZW5ndGggPT0gMQogICAgcmV0dXJuIGFyclswXQogIAogIGVsc2UKICAgIG1heDEgPSBhcnJbMF0KICAgIG1heDIgPSBhcnJbMV0KCiAgICBpZiBtYXgxIDwgbWF4MgogICAgICBtYXgxLG1heDIgPSBtYXgyLG1heDEKICAgIGVuZAogICAgKDIuLi5hcnIubGVuZ3RoKS5lYWNoIGRvIHxpfAogICAgICBpZiBhcnJbaV0gPiBtYXgxCiAgICAgICAgbWF4MixtYXgxID0gbWF4MSwgYXJyW2ldCiAgICAgIGVsc2lmIGFycltpXSA+IG1heDIKICAgICAgICBtYXgyID0gYXJyW2ldCiAgICAgIGVuZAogICAgZW5kCiAgICByZXR1cm4gbWF4MSArIG1heDIKICBlbmQKZW5kCgpkZWYgc3VtX3RvX24/IGFyciwgbgogICNEZWZpbmUgYSBtZXRob2QgYHN1bV90b19uPyhhcnJheSwgbilgIHRoYXQgdGFrZXMgYW4gYXJyYXkgb2YgaW50ZWdlcnMgYW5kIGFuIGFkZGl0aW9uYWwgaW50ZWdlciwgbiwgYXMgYXJndW1lbnRzIGFuZCByZXR1cm5zIHRydWUgaWYgYW55IHR3byBlbGVtZW50cyBpbiB0aGUgYXJyYXkgb2YgaW50ZWdlcnMgc3VtIHRvIG4uIGBzdW1fdG9fbj8oW10sIG4pYCBzaG91bGQgcmV0dXJuIGZhbHNlIGZvciBhbnkgdmFsdWUgb2YgbiwgYnkgZGVmaW5pdGlvbi4gCiAgI1J1biBhc3NvY2lhdGVkIHRlc3RzIHZpYTogIGAkIHJzcGVjIC1lICcjc3VtX3RvX24nIHNwZWMvcGFydDFfc3BlYy5yYmAgCiAgIyBZT1VSIENPREUgSEVSRQogIGlmIGFyci5sZW5ndGggPD0gMQogICAgcmV0dXJuIGZhbHNlCiAgZWxzZQogICAgKDAuLi5hcnIubGVuZ3RoLTEpLmVhY2ggZG8gfGkxfAogICAgICAoaTErMS4uLmFyci5sZW5ndGgpLmVhY2ggZG8gfGkyfAogICAgICAgIGlmIGFycltpMV0gKyBhcnJbaTJdID09IG4KICAgICAgICAgIHJldHVybiB0cnVlCiAgICAgICAgZW5kCiAgICAgIGVuZAogICAgZW5kCiAgICByZXR1cm4gZmFsc2UKICBlbmQKZW5kCgojIFBhcnQgMgoKZGVmIGhlbGxvKG5hbWUpCiAgI0RlZmluZSBhIG1ldGhvZCBgaGVsbG8obmFtZSlgIHRoYXQgdGFrZXMgYSBzdHJpbmcgcmVwcmVzZW50aW5nIGEgbmFtZSBhbmQgcmV0dXJucyB0aGUgc3RyaW5nICJIZWxsbywgIiBjb25jYXRlbmF0ZWQgd2l0aCB0aGUgbmFtZS4gCiAgI1J1biBhc3NvY2lhdGVkIHRlc3RzIHZpYTogIGAkIHJzcGVjIC1lICcjaGVsbG8nIHNwZWMvcGFydDJfc3BlYy5yYmAKICAjIFlPVVIgQ09ERSBIRVJFCmVuZAoKZGVmIHN0YXJ0c193aXRoX2NvbnNvbmFudD8gcwogICNEZWZpbmUgYSBtZXRob2QgYHN0YXJ0c193aXRoX2NvbnNvbmFudD8ocylgIHRoYXQgdGFrZXMgYSBzdHJpbmcgYW5kIHJldHVybnMgdHJ1ZSBpZiBpdCBzdGFydHMgd2l0aCBhIGNvbnNvbmFudCBhbmQgZmFsc2Ugb3RoZXJ3aXNlLiAoRm9yIG91ciBwdXJwb3NlcywgYSBjb25zb25hbnQgaXMgYW55IEVuZ2xpc2ggbGV0dGVyIG90aGVyIHRoYW4gQSwgRSwgSSwgTywgVS4pIE1ha2Ugc3VyZSBpdCB3b3JrcyBmb3IgYm90aCB1cHBlciBhbmQgbG93ZXIgY2FzZSBhbmQgZm9yIG5vbi1sZXR0ZXJzLiAKICAjUnVuIGFzc29jaWF0ZWQgdGVzdHMgdmlhOiAgYCQgcnNwZWMgLWUgJyNzdGFydHNfd2l0aF9jb25zb25hbnQ/JyBzcGVjL3BhcnQyX3NwZWMucmJgCiAgIyBZT1VSIENPREUgSEVSRQplbmQKCmRlZiBiaW5hcnlfbXVsdGlwbGVfb2ZfND8gcwogICNEZWZpbmUgYSBtZXRob2QgYGJpbmFyeV9tdWx0aXBsZV9vZl80PyhzKWAgdGhhdCB0YWtlcyBhIHN0cmluZyBhbmQgcmV0dXJucyB0cnVlIGlmIHRoZSBzdHJpbmcgcmVwcmVzZW50cyBhIGJpbmFyeSBudW1iZXIgdGhhdCBpcyBhIG11bHRpcGxlIG9mIDQsIHN1Y2ggYXMgJzEwMDAnLiBNYWtlIHN1cmUgaXQgcmV0dXJucyBmYWxzZSBpZiB0aGUgc3RyaW5nIGlzIG5vdCBhIHZhbGlkIGJpbmFyeSBudW1iZXIuIAogICNSdW4gYXNzb2NpYXRlZCB0ZXN0cyB2aWE6ICBgJCByc3BlYyAtZSAnI2JpbmFyeV9tdWx0aXBsZV9vZl80Pycgc3BlYy9wYXJ0Ml9zcGVjLnJiYAogICMgWU9VUiBDT0RFIEhFUkUKZW5kCgojIFBhcnQgMwoKY2xhc3MgQm9va0luU3RvY2sKICAjRGVmaW5lIGEgY2xhc3MgYEJvb2tJblN0b2NrYCB3aGljaCByZXByZXNlbnRzIGEgYm9vayB3aXRoIGFuIElTQk4gbnVtYmVyLCBgaXNibmAsIGFuZCBwcmljZSBvZiB0aGUgYm9vayBhcyBhIGZsb2F0aW5nLXBvaW50IG51bWJlciwgYHByaWNlYCwgYXMgYXR0cmlidXRlcy4gCiAgI1J1biBhc3NvY2lhdGVkIHRlc3RzIHZpYTogIGAkIHJzcGVjIC1lICdnZXR0ZXJzIGFuZCBzZXR0ZXJzJyBzcGVjL3BhcnQzX3NwZWMucmJgIChNYWtlIHN1cmUgeW91IGFyZSBpbiB0aGUgY29ycmVjdCBkaXJlY3Rvcnk6IGBjZCBhc3NpZ25tZW50YCkKICAjVGhlIGNvbnN0cnVjdG9yIHNob3VsZCBhY2NlcHQgdGhlIElTQk4gbnVtYmVyIChhIHN0cmluZywgc2luY2UgaW4gcmVhbCBsaWZlIElTQk4gbnVtYmVycyBjYW4gYmVnaW4gd2l0aCB6ZXJvIGFuZCBjYW4gaW5jbHVkZSBoeXBoZW5zKSBhcyB0aGUgZmlyc3QgYXJndW1lbnQgYW5kIHByaWNlIGFzIHNlY29uZCBhcmd1bWVudCwgYW5kIHNob3VsZCByYWlzZSBgQXJndW1lbnRFcnJvcmAgKG9uZSBvZiBSdWJ5J3MgYnVpbHQtaW4gZXhjZXB0aW9uIHR5cGVzKSBpZiB0aGUgSVNCTiBudW1iZXIgaXMgdGhlIGVtcHR5IHN0cmluZyBvciBpZiB0aGUgcHJpY2UgaXMgbGVzcyB0aGFuIG9yIGVxdWFsIHRvIHplcm8uICBJbmNsdWRlIHRoZSBwcm9wZXIgZ2V0dGVycyBhbmQgc2V0dGVycyBmb3IgdGhlc2UgYXR0cmlidXRlcy4gUnVuIGFzc29jaWF0ZWQgdGVzdHMgdmlhOiAgYCQgcnNwZWMgLWUgJ2NvbnN0cnVjdG9yJyBzcGVjL3BhcnQzX3NwZWMucmJgCiAgI0luY2x1ZGUgYSBtZXRob2QgYHByaWNlX2FzX3N0cmluZ2AgdGhhdCByZXR1cm5zIHRoZSBwcmljZSBvZiB0aGUgYm9vayBmb3JtYXR0ZWQgd2l0aCBhIGxlYWRpbmcgZG9sbGFyIHNpZ24gYW5kIHR3byBkZWNpbWFsIHBsYWNlcywgdGhhdCBpcywgYSBwcmljZSBvZiAyMCBzaG91bGQgZm9ybWF0IGFzIGAkMjAuMDBgIGFuZCBhIHByaWNlIG9mIDMzLjggc2hvdWxkIGZvcm1hdCBhcyBgJDMzLjgwYC4gQ2hlY2sgb3V0IGZvcm1hdHRlZCBzdHJpbmcgbWV0aG9kcyBpbiBSdWJ5LiBSdW4gYXNzb2NpYXRlZCB0ZXN0cyB2aWE6ICBgJCByc3BlYyAtZSAnI3ByaWNlX2FzX3N0cmluZycgc3BlYy9wYXJ0M19zcGVjLnJiYAojIFlPVVIgQ09ERSBIRVJFCmVuZAo=\r\n-----011000010111000001101001--"

    response = http.request(request)
    puts response.read_body
    
    #####################################


    form_data = [['file', file_data_decoded]]
    request.set_form(form_data, 'multipart/form-data')
    
    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    if response.code == '200'
      result = JSON.parse(response.body)
      #@scan.update_scan_id(result["data"]["id"])
    else
      raise "Error uploading file to VirusTotal: #{response.body}"
    end
  end

  def fetch_report
    uri = URI.parse("https://www.virustotal.com/api/v3/analyses/#{scan_id}")
    request = Net::HTTP::Get.new(uri)
    request["x-apikey"] = @api_key

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    if response.code == '200'
      JSON.parse(response.body)
    else
      raise "Error retrieving report from VirusTotal: #{response.body}"
    end
  end
end
json.extract! scan, :id, :file_name, :file_type, :hashcode, :file_size, :upload_date, :vote_up, :vote_down, :created_at, :updated_at
json.url scan_url(scan, format: :json)

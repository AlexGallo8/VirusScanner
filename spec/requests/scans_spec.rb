require 'rails_helper'

RSpec.describe "Scans", type: :request do
  let(:user) { create(:user) }
  let(:scan) { create(:scan, :with_result, user: user) }

  before do
    login_as(user)
  end

  describe "POST /scans" do
    it "creates a new scan" do
      file = fixture_file_upload('spec/fixtures/files/test.pdf', 'application/pdf')
      
      # Create a test double
      virus_total_service = double('VirusTotalService')
      allow(VirusTotalService).to receive(:new).and_return(virus_total_service)
      allow(virus_total_service).to receive(:upload_file).and_return({ "data" => { "id" => "test_id" } })
      
      expect {
        post scans_path, params: { 
          scan: {
            hashcode: Digest::SHA256.hexdigest(File.read(file.path)),
            file_name: file.original_filename,
            file_type: file.content_type,
            file_size: file.size,
            upload_date: Time.current
          }
        }
      }.to change(Scan, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "POST /scans/:id/upvote" do
    it "increases vote count" do
      expect {
        post upvote_scan_path(scan)
      }.to change { scan.reload.vote_up }.by(1)
    end
  end

  describe "POST /scans/:id/comments" do
    it "creates a comment" do
      expect {
        post scan_comments_path(scan), params: { comment: { content: "Test comment" } }
      }.to change(Comment, :count).by(1)
    end
  end
end
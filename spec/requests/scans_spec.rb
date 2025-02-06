require 'rails_helper'

RSpec.describe "Scans", type: :request do
  let(:user) { create(:user) }
  let(:scan) { create(:scan, :with_results, user: user) }

  before do
    sign_in user
  end

  describe "POST /scans" do
    it "creates a new scan" do
      file = fixture_file_upload('spec/fixtures/files/test.pdf', 'application/pdf')
      
      expect {
        post scans_path, params: { scan: { file: file } }
      }.to change(Scan, :count).by(1)

      expect(response).to redirect_to(scan_path(Scan.last))
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
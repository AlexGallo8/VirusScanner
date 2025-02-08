require 'rails_helper'

RSpec.describe Scan, type: :model do
  let(:scan) { build(:scan) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(scan).to be_valid
    end

    it "is not valid without a hashcode" do
      scan.hashcode = nil
      expect(scan).not_to be_valid
    end
    
    it "is not valid with a duplicate hashcode" do
      existing_scan = create(:scan)
      scan.hashcode = existing_scan.hashcode
      expect(scan).not_to be_valid
    end
  end

  describe "vote counters" do
    it "initializes with zero votes" do
      expect(scan.vote_up).to eq(0)
      expect(scan.vote_down).to eq(0)
    end
  end

  describe "scan results" do
    it "stores and retrieves VirusTotal scan results as JSON" do
      vt_response = {
        'data' => {
          'id' => 'test_scan_id',
          'attributes' => {
            'stats' => {
              'malicious' => 2,
              'undetected' => 3
            }
          }
        }
      }
      
      scan.scan_result = vt_response
      scan.save
      scan.reload
      
      expect(scan.scan_result['data']['id']).to eq('test_scan_id')
      expect(scan.scan_result['data']['attributes']['stats']['malicious']).to eq(2)
    end
  end
end
require 'rails_helper'

RSpec.describe Scan, type: :model do
  let(:scan) { build(:scan) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(scan).to be_valid
    end

    it "is not valid without a file_name" do
      scan.file_name = nil
      expect(scan).not_to be_valid
    end
  end

  describe "#process_results" do
    it "correctly processes scan results" do
      scan.results = {
        'engine1' => { 'category' => 'malicious' },
        'engine2' => { 'category' => 'undetected' }
      }
      
      expect(scan.malicious_count).to eq(1)
      expect(scan.clean_count).to eq(1)
    end
  end
end
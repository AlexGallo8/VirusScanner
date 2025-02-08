require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "is not valid without an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "is not valid with a duplicate email" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).not_to be_valid
    end

    it "automatically generates username from email" do
      user = create(:user, :with_test_email)
      expect(user.username).to eq("test.user")
    end

    it "ensures generated usernames are unique" do
      create(:user, email: "test.user@example.com")
      user2 = create(:user, email: "different.test.user@example.com")
      expect(user2.username).not_to eq("test.user")
    end
  end

  describe "associations" do
    it "has many scans" do
      user = create(:user)
      expect(user.scans).to be_empty
      
      scan = create(:scan)
      create(:scan_user, user: user, scan: scan)
      
      expect(user.reload.scans).to include(scan)
    end

    it "has many comments" do
      user = create(:user)
      expect(user.comments).to be_empty
      
      comment = create(:comment, user: user)
      expect(user.reload.comments).to include(comment)
    end
  end
end
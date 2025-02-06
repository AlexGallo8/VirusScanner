require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "is not valid without a username" do
      user = build(:user, username: nil)
      expect(user).not_to be_valid
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

    it "is not valid with a duplicate username" do
      create(:user, username: "testuser")
      user = build(:user, username: "testuser")
      expect(user).not_to be_valid
    end
  end

  describe "associations" do
    it "has many scans" do
      user = create(:user)
      expect(user.scans).to be_empty
      
      scan = create(:scan, user: user)
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
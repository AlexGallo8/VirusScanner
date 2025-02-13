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
    
    it "is not valid with an invalid password" do
      # Test cases for invalid passwords
      invalid_passwords = [
        "short", # too short
        "password123", # missing uppercase and special char
        "PASSWORD123!", # missing lowercase
        "Password123", # missing special char
        "Password!!!", # missing number
        "pass 123 !", # contains space
      ]
    
      invalid_passwords.each do |password|
        user = build(:user, password: password)
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include(
          "must be at least 8 characters long and include: 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character"
        )
      end
    
      # Verify that a valid password works
      user = build(:user, password: "Password123!")
      expect(user).to be_valid
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
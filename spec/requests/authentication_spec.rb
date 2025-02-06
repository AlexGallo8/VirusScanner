require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe "POST /users" do
    let(:valid_attributes) {
      {
        user: {
          username: "testuser",
          email: "test@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    }

    it "creates a new user" do
      expect {
        post user_registration_path, params: valid_attributes
      }.to change(User, :count).by(1)
      
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Welcome!")
    end
  end

  describe "POST /users/sign_in" do
    let(:user) { create(:user) }

    it "signs in the user" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: user.password
        }
      }
      
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include(user.username)
    end
  end

  describe "DELETE /users/sign_out" do
    let(:user) { create(:user) }

    it "signs out the user" do
      sign_in user
      delete destroy_user_session_path
      
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).not_to include(user.username)
    end
  end
end
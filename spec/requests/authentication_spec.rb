require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe "POST /users" do
    let(:valid_attributes) {
      {
        email: "test@example.com",
        password: "Password123!",
        password_confirmation: "Password123!"
      }
    }

    it "creates a new user" do
      expect {
        post registration_path, params: { user: valid_attributes }
      }.to change(User, :count).by(1)
      
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Successfully created account!")
    end
  end

  describe "POST /users/sign_in" do
    let(:user) { create(:user, email: "test@example.com", password: "Password123!") }

    it "signs in the user" do
      post session_path, params: {
        email: user.email,
        password: "Password123!"
      }
      
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include(user.username)
    end
  end

  describe "DELETE /users/sign_out" do
    let(:user) { create(:user, email: "test@example.com", password: "Password123!") }

    it "signs out the user" do
      # Prima facciamo il login
      post session_path, params: {
        email: user.email,
        password: "Password123!"
      }
      
      # Poi facciamo il logout
      delete session_path
      
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).not_to include(user.username)
    end
  end
end
require 'rails_helper'

RSpec.feature "Authentication", type: :feature do
  scenario "User can sign up" do
    visit new_registration_path
    
    within('form[data-test-id="signup-page-registration-form-123"]') do
      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "Password123!"
      fill_in "Password confirmation", with: "Password123!"
      click_button "Sign Up"
    end
    
    expect(page).to have_content("Successfully created account!")
  end

  scenario "User can sign in" do
    user = create(:user, email: "test@example.com", password: "Password123!")
    
    visit new_session_path
    within('form[data-test-id="login-page-session-form-123"]') do
      fill_in "Email", with: user.email
      fill_in "Password", with: "Password123!"
      click_button "Log in"
    end
    
    expect(page).to have_content("You have signed in successfully")
  end

  scenario "User can sign out" do
    user = create(:user, email: "test@example.com", password: "Password123!")
    
    # Log in first
    visit new_session_path
    within('form[data-test-id="login-page-session-form-123"]') do
      fill_in "Email", with: user.email
      fill_in "Password", with: "Password123!"
      click_button "Log in"
    end
    
    # Then try to log out
    click_button "Log out"
    expect(page).to have_content("You have been logged out")
  end
end
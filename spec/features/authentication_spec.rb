require 'rails_helper'

RSpec.feature "Authentication", type: :feature do
  scenario "User can sign up" do
    visit new_registration_path
    
    within('[data-test-id="registration-form"]') do
      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "Password123!"
      fill_in "Password confirmation", with: "Password123!"
      click_button "Sign Up"
    end
    
    expect(page).to have_content("Account created successfully")
  end

  scenario "User can sign in" do
    user = create(:user, email: "test@example.com", password: "Password123!")
    
    visit new_session_path
    within('[data-test-id="login-form"]') do
      fill_in "Email", with: user.email
      fill_in "Password", with: "Password123!"
      click_button "Log in"
    end
    
    expect(page).to have_content("Logged in successfully")
  end

  scenario "User can sign out" do
    user = create(:user)
    sign_in(user)
    
    find('a', text: 'Logout').click
    expect(page).to have_content("Logged out successfully")
  end
end
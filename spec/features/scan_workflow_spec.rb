require 'rails_helper'

RSpec.feature "Scan Workflow", type: :feature do
  let(:user) { create(:user) }

  before do
    visit new_session_path
    within("#session_form") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
    end
  end

  scenario "User uploads a file and views results", js: true do
    visit root_path
    
    test_file_path = Rails.root.join('spec/fixtures/files/test.pdf')
    File.write(test_file_path, "Test content") unless File.exist?(test_file_path)
    
    # Make file input visible for testing
    page.execute_script("document.getElementById('fileInput').classList.remove('hidden')")
    attach_file("fileInput", test_file_path)
    
    # Target the specific form for regular file uploads
    within('#box1 .grid-cols-1 > div:first-child form') do
      click_button "Scan File"
    end

    # Wait for loading screen to appear
    expect(page).to have_css('.loading-overlay', wait: 5)
    expect(page).to have_content('Scanning in Progress')
    
    # Wait for final results
    expect(page).to have_content("Scan Results")
    # , wait: 120)
    expect(page).to have_content("test.pdf")
  end

  scenario "User comments on a scan" do
    scan = create(:scan, :with_result, user: user)
    visit scan_path(scan)

    fill_in "comment[content]", with: "Test comment"
    click_button "Pubblica commento"

    expect(page).to have_content("Test comment")
  end

  scenario "User votes on a scan" do
    scan = create(:scan, :with_result)
    visit scan_path(scan)

    find("form[action='#{upvote_scan_path(scan)}'] button").click
    
    # Update to match the actual vote count display in the view
    expect(page).to have_css(".text-lg.font-bold.text-green-600", text: "1")
  end
end
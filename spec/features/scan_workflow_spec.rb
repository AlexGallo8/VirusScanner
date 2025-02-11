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

  scenario "User uploads a file", js: true do
    visit root_path
    
    test_file_path = Rails.root.join('spec/fixtures/files/test.pdf')
    unless File.exist?(test_file_path)
      require 'prawn'
      Prawn::Document.generate(test_file_path) do |pdf|
        pdf.text "Test PDF Document"
        pdf.text "This is a sample content for testing"
        pdf.text Time.current.to_s
      end
    end
    
    # Make file input visible and attach file
    page.execute_script("document.getElementById('fileInput').classList.remove('hidden')")
    attach_file("fileInput", test_file_path)
    
    # Submit the form
    within('#box1 .grid-cols-1 > div:first-child form') do
      click_button "Scan File"
    end

    # Verify loading state is shown
    expect(page).to have_css('.loading-overlay')
    expect(page).to have_content('Scanning in Progress')
  end

  scenario "User views scan results" do
    scan = create(:scan, :with_result)
    visit scan_path(scan)
    
    expect(page).to have_content("Malicious")
    expect(page).to have_content("Undetected")
  end

  scenario "User comments on a scan" do
    scan = create(:scan, :with_result, user: user)
    visit scan_path(scan)

    fill_in "comment[content]", with: "Test comment"
    click_button "Post Comment"

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
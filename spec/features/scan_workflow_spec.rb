require 'rails_helper'

RSpec.feature "Scan Workflow", type: :feature do
  let(:user) { create(:user) }

  before do
    visit new_session_path
    within("form[action='#{session_path}']:first") do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
    end
  end

  scenario "User uploads a file and views results" do
    visit virus_total_path
    
    attach_file("scan[file]", Rails.root.join("spec/fixtures/files/test.pdf"))
    click_button "Scan File"

    expect(page).to have_content("Risultati della Scansione")
    expect(page).to have_content("test.pdf")
  end

  scenario "User comments on a scan" do
    scan = create(:scan, :with_results, user: user)
    visit scan_path(scan)

    fill_in "comment[content]", with: "Test comment"
    click_button "Pubblica commento"

    expect(page).to have_content("Test comment")
  end

  scenario "User votes on a scan" do
    scan = create(:scan, :with_results)
    visit scan_path(scan)

    find("button[name='upvote']").click
    
    expect(page).to have_css(".vote-count", text: "1")
  end
end
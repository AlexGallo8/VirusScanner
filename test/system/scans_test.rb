require "application_system_test_case"

class ScansTest < ApplicationSystemTestCase
  setup do
    @scan = scans(:one)
  end

  test "visiting the index" do
    visit scans_url
    assert_selector "h1", text: "Scans"
  end

  test "should create scan" do
    visit scans_url
    click_on "New scan"

    fill_in "File name", with: @scan.file_name
    fill_in "File size", with: @scan.file_size
    fill_in "File type", with: @scan.file_type
    fill_in "Hashcode", with: @scan.hashcode
    fill_in "Upload date", with: @scan.upload_date
    fill_in "Vote down", with: @scan.vote_down
    fill_in "Vote up", with: @scan.vote_up
    click_on "Create Scan"

    assert_text "Scan was successfully created"
    click_on "Back"
  end

  test "should update Scan" do
    visit scan_url(@scan)
    click_on "Edit this scan", match: :first

    fill_in "File name", with: @scan.file_name
    fill_in "File size", with: @scan.file_size
    fill_in "File type", with: @scan.file_type
    fill_in "Hashcode", with: @scan.hashcode
    fill_in "Upload date", with: @scan.upload_date
    fill_in "Vote down", with: @scan.vote_down
    fill_in "Vote up", with: @scan.vote_up
    click_on "Update Scan"

    assert_text "Scan was successfully updated"
    click_on "Back"
  end

  test "should destroy Scan" do
    visit scan_url(@scan)
    click_on "Destroy this scan", match: :first

    assert_text "Scan was successfully destroyed"
  end
end

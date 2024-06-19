require "test_helper"

class ScansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scan = scans(:one)
  end

  test "should get index" do
    get scans_url
    assert_response :success
  end

  test "should get new" do
    get new_scan_url
    assert_response :success
  end

  test "should create scan" do
    assert_difference("Scan.count") do
      post scans_url, params: { scan: { file_name: @scan.file_name, file_size: @scan.file_size, file_type: @scan.file_type, hashcode: @scan.hashcode, upload_date: @scan.upload_date, vote_down: @scan.vote_down, vote_up: @scan.vote_up } }
    end

    assert_redirected_to scan_url(Scan.last)
  end

  test "should show scan" do
    get scan_url(@scan)
    assert_response :success
  end

  test "should get edit" do
    get edit_scan_url(@scan)
    assert_response :success
  end

  test "should update scan" do
    patch scan_url(@scan), params: { scan: { file_name: @scan.file_name, file_size: @scan.file_size, file_type: @scan.file_type, hashcode: @scan.hashcode, upload_date: @scan.upload_date, vote_down: @scan.vote_down, vote_up: @scan.vote_up } }
    assert_redirected_to scan_url(@scan)
  end

  test "should destroy scan" do
    assert_difference("Scan.count", -1) do
      delete scan_url(@scan)
    end

    assert_redirected_to scans_url
  end
end

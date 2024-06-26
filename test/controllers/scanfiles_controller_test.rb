require "test_helper"

class ScanfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get scanfiles_new_url
    assert_response :success
  end

  test "should get create" do
    get scanfiles_create_url
    assert_response :success
  end

  test "should get show" do
    get scanfiles_show_url
    assert_response :success
  end
end

require "test_helper"

class SimilarsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get similars_new_url
    assert_response :success
  end

  test "should get create" do
    get similars_create_url
    assert_response :success
  end
end

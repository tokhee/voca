require "test_helper"

class QuizQuestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get quiz_questions_show_url
    assert_response :success
  end

  test "should get update" do
    get quiz_questions_update_url
    assert_response :success
  end
end

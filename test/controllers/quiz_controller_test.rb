require "test_helper"

class QuizControllerTest < ActionDispatch::IntegrationTest
  test "should get start" do
    get quiz_start_url
    assert_response :success
  end

  test "should get next_question" do
    get quiz_next_question_url
    assert_response :success
  end

  test "should get evaluate" do
    get quiz_evaluate_url
    assert_response :success
  end

  test "should get results" do
    get quiz_results_url
    assert_response :success
  end
end

require 'test_helper'

class BiweeklyPersonalityGradesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:biweekly_personality_grades)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create biweekly_personality_grade" do
    assert_difference('BiweeklyPersonalityGrade.count') do
      post :create, :biweekly_personality_grade => { }
    end

    assert_redirected_to biweekly_personality_grade_path(assigns(:biweekly_personality_grade))
  end

  test "should show biweekly_personality_grade" do
    get :show, :id => biweekly_personality_grades(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => biweekly_personality_grades(:one).to_param
    assert_response :success
  end

  test "should update biweekly_personality_grade" do
    put :update, :id => biweekly_personality_grades(:one).to_param, :biweekly_personality_grade => { }
    assert_redirected_to biweekly_personality_grade_path(assigns(:biweekly_personality_grade))
  end

  test "should destroy biweekly_personality_grade" do
    assert_difference('BiweeklyPersonalityGrade.count', -1) do
      delete :destroy, :id => biweekly_personality_grades(:one).to_param
    end

    assert_redirected_to biweekly_personality_grades_path
  end
end

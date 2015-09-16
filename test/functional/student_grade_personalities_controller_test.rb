require 'test_helper'

class StudentGradePersonalitiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_grade_personalities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_grade_personality" do
    assert_difference('StudentGradePersonality.count') do
      post :create, :student_grade_personality => { }
    end

    assert_redirected_to student_grade_personality_path(assigns(:student_grade_personality))
  end

  test "should show student_grade_personality" do
    get :show, :id => student_grade_personalities(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => student_grade_personalities(:one).to_param
    assert_response :success
  end

  test "should update student_grade_personality" do
    put :update, :id => student_grade_personalities(:one).to_param, :student_grade_personality => { }
    assert_redirected_to student_grade_personality_path(assigns(:student_grade_personality))
  end

  test "should destroy student_grade_personality" do
    assert_difference('StudentGradePersonality.count', -1) do
      delete :destroy, :id => student_grade_personalities(:one).to_param
    end

    assert_redirected_to student_grade_personalities_path
  end
end

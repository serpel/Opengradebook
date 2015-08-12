require 'test_helper'

class BiweeklySubjectGradesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:biweekly_subject_grades)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create biweekly_subject_grade" do
    assert_difference('BiweeklySubjectGrade.count') do
      post :create, :biweekly_subject_grade => { }
    end

    assert_redirected_to biweekly_subject_grade_path(assigns(:biweekly_subject_grade))
  end

  test "should show biweekly_subject_grade" do
    get :show, :id => biweekly_subject_grades(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => biweekly_subject_grades(:one).to_param
    assert_response :success
  end

  test "should update biweekly_subject_grade" do
    put :update, :id => biweekly_subject_grades(:one).to_param, :biweekly_subject_grade => { }
    assert_redirected_to biweekly_subject_grade_path(assigns(:biweekly_subject_grade))
  end

  test "should destroy biweekly_subject_grade" do
    assert_difference('BiweeklySubjectGrade.count', -1) do
      delete :destroy, :id => biweekly_subject_grades(:one).to_param
    end

    assert_redirected_to biweekly_subject_grades_path
  end
end

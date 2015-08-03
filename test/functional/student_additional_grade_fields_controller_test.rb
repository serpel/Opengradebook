require 'test_helper'

class StudentAdditionalGradeFieldsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_additional_grade_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_additional_grade_field" do
    assert_difference('StudentAdditionalGradeField.count') do
      post :create, :student_additional_grade_field => { }
    end

    assert_redirected_to student_additional_grade_field_path(assigns(:student_additional_grade_field))
  end

  test "should show student_additional_grade_field" do
    get :show, :id => student_additional_grade_fields(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => student_additional_grade_fields(:one).to_param
    assert_response :success
  end

  test "should update student_additional_grade_field" do
    put :update, :id => student_additional_grade_fields(:one).to_param, :student_additional_grade_field => { }
    assert_redirected_to student_additional_grade_field_path(assigns(:student_additional_grade_field))
  end

  test "should destroy student_additional_grade_field" do
    assert_difference('StudentAdditionalGradeField.count', -1) do
      delete :destroy, :id => student_additional_grade_fields(:one).to_param
    end

    assert_redirected_to student_additional_grade_fields_path
  end
end

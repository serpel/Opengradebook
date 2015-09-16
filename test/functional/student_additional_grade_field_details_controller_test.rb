require 'test_helper'

class StudentAdditionalGradeFieldDetailsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_additional_grade_field_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_additional_grade_field_detail" do
    assert_difference('StudentAdditionalGradeFieldDetail.count') do
      post :create, :student_additional_grade_field_detail => { }
    end

    assert_redirected_to student_additional_grade_field_detail_path(assigns(:student_additional_grade_field_detail))
  end

  test "should show student_additional_grade_field_detail" do
    get :show, :id => student_additional_grade_field_details(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => student_additional_grade_field_details(:one).to_param
    assert_response :success
  end

  test "should update student_additional_grade_field_detail" do
    put :update, :id => student_additional_grade_field_details(:one).to_param, :student_additional_grade_field_detail => { }
    assert_redirected_to student_additional_grade_field_detail_path(assigns(:student_additional_grade_field_detail))
  end

  test "should destroy student_additional_grade_field_detail" do
    assert_difference('StudentAdditionalGradeFieldDetail.count', -1) do
      delete :destroy, :id => student_additional_grade_field_details(:one).to_param
    end

    assert_redirected_to student_additional_grade_field_details_path
  end
end

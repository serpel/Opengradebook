require 'test_helper'

class StudentGeneralDetailsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_general_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_general_detail" do
    assert_difference('StudentGeneralDetail.count') do
      post :create, :student_general_detail => { }
    end

    assert_redirected_to student_general_detail_path(assigns(:student_general_detail))
  end

  test "should show student_general_detail" do
    get :show, :id => student_general_details(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => student_general_details(:one).to_param
    assert_response :success
  end

  test "should update student_general_detail" do
    put :update, :id => student_general_details(:one).to_param, :student_general_detail => { }
    assert_redirected_to student_general_detail_path(assigns(:student_general_detail))
  end

  test "should destroy student_general_detail" do
    assert_difference('StudentGeneralDetail.count', -1) do
      delete :destroy, :id => student_general_details(:one).to_param
    end

    assert_redirected_to student_general_details_path
  end
end

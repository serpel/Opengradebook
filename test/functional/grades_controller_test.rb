require 'test_helper'

class GradesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grades)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grade" do
    assert_difference('Grade.count') do
      post :create, :grade => { }
    end

    assert_redirected_to grade_path(assigns(:grade))
  end

  test "should show grade" do
    get :show, :id => grades(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => grades(:one).to_param
    assert_response :success
  end

  test "should update grade" do
    put :update, :id => grades(:one).to_param, :grade => { }
    assert_redirected_to grade_path(assigns(:grade))
  end

  test "should destroy grade" do
    assert_difference('Grade.count', -1) do
      delete :destroy, :id => grades(:one).to_param
    end

    assert_redirected_to grades_path
  end
end

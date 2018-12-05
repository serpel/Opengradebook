require 'test_helper'

class PeriodsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:periods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create period" do
    assert_difference('Period.count') do
      post :create, :period => { }
    end

    assert_redirected_to period_path(assigns(:period))
  end

  test "should show period" do
    get :show, :id => periods(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => periods(:one).to_param
    assert_response :success
  end

  test "should update period" do
    put :update, :id => periods(:one).to_param, :period => { }
    assert_redirected_to period_path(assigns(:period))
  end

  test "should destroy period" do
    assert_difference('Period.count', -1) do
      delete :destroy, :id => periods(:one).to_param
    end

    assert_redirected_to periods_path
  end
end

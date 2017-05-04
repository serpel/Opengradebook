require 'test_helper'

class PrivilegesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:privileges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create privilege" do
    assert_difference('Privilege.count') do
      post :create, :privilege => { }
    end

    assert_redirected_to privilege_path(assigns(:privilege))
  end

  test "should show privilege" do
    get :show, :id => privileges(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => privileges(:one).to_param
    assert_response :success
  end

  test "should update privilege" do
    put :update, :id => privileges(:one).to_param, :privilege => { }
    assert_redirected_to privilege_path(assigns(:privilege))
  end

  test "should destroy privilege" do
    assert_difference('Privilege.count', -1) do
      delete :destroy, :id => privileges(:one).to_param
    end

    assert_redirected_to privileges_path
  end
end

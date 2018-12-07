require 'test_helper'

class PonderationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ponderations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ponderation" do
    assert_difference('Ponderation.count') do
      post :create, :ponderation => { }
    end

    assert_redirected_to ponderation_path(assigns(:ponderation))
  end

  test "should show ponderation" do
    get :show, :id => ponderations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ponderations(:one).to_param
    assert_response :success
  end

  test "should update ponderation" do
    put :update, :id => ponderations(:one).to_param, :ponderation => { }
    assert_redirected_to ponderation_path(assigns(:ponderation))
  end

  test "should destroy ponderation" do
    assert_difference('Ponderation.count', -1) do
      delete :destroy, :id => ponderations(:one).to_param
    end

    assert_redirected_to ponderations_path
  end
end

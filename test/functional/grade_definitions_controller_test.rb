require 'test_helper'

class GradeDefinitionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grade_definitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grade_definition" do
    assert_difference('GradeDefinition.count') do
      post :create, :grade_definition => { }
    end

    assert_redirected_to grade_definition_path(assigns(:grade_definition))
  end

  test "should show grade_definition" do
    get :show, :id => grade_definitions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => grade_definitions(:one).to_param
    assert_response :success
  end

  test "should update grade_definition" do
    put :update, :id => grade_definitions(:one).to_param, :grade_definition => { }
    assert_redirected_to grade_definition_path(assigns(:grade_definition))
  end

  test "should destroy grade_definition" do
    assert_difference('GradeDefinition.count', -1) do
      delete :destroy, :id => grade_definitions(:one).to_param
    end

    assert_redirected_to grade_definitions_path
  end
end

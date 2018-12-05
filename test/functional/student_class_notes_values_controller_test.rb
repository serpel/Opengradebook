require 'test_helper'

class StudentClassNotesValuesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_class_notes_values)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_class_notes_value" do
    assert_difference('StudentClassNotesValue.count') do
      post :create, :student_class_notes_value => { }
    end

    assert_redirected_to student_class_notes_value_path(assigns(:student_class_notes_value))
  end

  test "should show student_class_notes_value" do
    get :show, :id => student_class_notes_values(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => student_class_notes_values(:one).to_param
    assert_response :success
  end

  test "should update student_class_notes_value" do
    put :update, :id => student_class_notes_values(:one).to_param, :student_class_notes_value => { }
    assert_redirected_to student_class_notes_value_path(assigns(:student_class_notes_value))
  end

  test "should destroy student_class_notes_value" do
    assert_difference('StudentClassNotesValue.count', -1) do
      delete :destroy, :id => student_class_notes_values(:one).to_param
    end

    assert_redirected_to student_class_notes_values_path
  end
end

require 'test_helper'

class StudentClassNotesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_class_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_class_note" do
    assert_difference('StudentClassNote.count') do
      post :create, :student_class_note => { }
    end

    assert_redirected_to student_class_note_path(assigns(:student_class_note))
  end

  test "should show student_class_note" do
    get :show, :id => student_class_notes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => student_class_notes(:one).to_param
    assert_response :success
  end

  test "should update student_class_note" do
    put :update, :id => student_class_notes(:one).to_param, :student_class_note => { }
    assert_redirected_to student_class_note_path(assigns(:student_class_note))
  end

  test "should destroy student_class_note" do
    assert_difference('StudentClassNote.count', -1) do
      delete :destroy, :id => student_class_notes(:one).to_param
    end

    assert_redirected_to student_class_notes_path
  end
end

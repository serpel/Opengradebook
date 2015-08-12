require 'test_helper'

class SchoolReportsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:school_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create school_report" do
    assert_difference('SchoolReport.count') do
      post :create, :school_report => { }
    end

    assert_redirected_to school_report_path(assigns(:school_report))
  end

  test "should show school_report" do
    get :show, :id => school_reports(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => school_reports(:one).to_param
    assert_response :success
  end

  test "should update school_report" do
    put :update, :id => school_reports(:one).to_param, :school_report => { }
    assert_redirected_to school_report_path(assigns(:school_report))
  end

  test "should destroy school_report" do
    assert_difference('SchoolReport.count', -1) do
      delete :destroy, :id => school_reports(:one).to_param
    end

    assert_redirected_to school_reports_path
  end
end

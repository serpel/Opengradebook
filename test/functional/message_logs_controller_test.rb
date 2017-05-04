require 'test_helper'

class MessageLogsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_log" do
    assert_difference('MessageLog.count') do
      post :create, :message_log => { }
    end

    assert_redirected_to message_log_path(assigns(:message_log))
  end

  test "should show message_log" do
    get :show, :id => message_logs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => message_logs(:one).to_param
    assert_response :success
  end

  test "should update message_log" do
    put :update, :id => message_logs(:one).to_param, :message_log => { }
    assert_redirected_to message_log_path(assigns(:message_log))
  end

  test "should destroy message_log" do
    assert_difference('MessageLog.count', -1) do
      delete :destroy, :id => message_logs(:one).to_param
    end

    assert_redirected_to message_logs_path
  end
end

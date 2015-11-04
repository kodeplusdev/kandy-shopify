require 'test_helper'

class ChatWidgetsControllerTest < ActionController::TestCase
  setup do
    @chat_widget = chat_widgets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chat_widgets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create chat_widget" do
    assert_difference('ChatWidget.count') do
      post :create, chat_widget: { enabled: @chat_widget.enabled, json_string: @chat_widget.json_string, name: @chat_widget.name, shop_id: @chat_widget.shop_id }
    end

    assert_redirected_to chat_widget_path(assigns(:chat_widget))
  end

  test "should show chat_widget" do
    get :show, id: @chat_widget
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @chat_widget
    assert_response :success
  end

  test "should update chat_widget" do
    patch :update, id: @chat_widget, chat_widget: { enabled: @chat_widget.enabled, json_string: @chat_widget.json_string, name: @chat_widget.name, shop_id: @chat_widget.shop_id }
    assert_redirected_to chat_widget_path(assigns(:chat_widget))
  end

  test "should destroy chat_widget" do
    assert_difference('ChatWidget.count', -1) do
      delete :destroy, id: @chat_widget
    end

    assert_redirected_to chat_widgets_path
  end
end

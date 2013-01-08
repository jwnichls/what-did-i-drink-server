require 'test_helper'

class TempAccessTokensControllerTest < ActionController::TestCase
  setup do
    @temp_access_token = temp_access_tokens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:temp_access_tokens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create temp_access_token" do
    assert_difference('TempAccessToken.count') do
      post :create, temp_access_token: { token: @temp_access_token.token, user_id: @temp_access_token.user_id }
    end

    assert_redirected_to temp_access_token_path(assigns(:temp_access_token))
  end

  test "should show temp_access_token" do
    get :show, id: @temp_access_token
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @temp_access_token
    assert_response :success
  end

  test "should update temp_access_token" do
    put :update, id: @temp_access_token, temp_access_token: { token: @temp_access_token.token, user_id: @temp_access_token.user_id }
    assert_redirected_to temp_access_token_path(assigns(:temp_access_token))
  end

  test "should destroy temp_access_token" do
    assert_difference('TempAccessToken.count', -1) do
      delete :destroy, id: @temp_access_token
    end

    assert_redirected_to temp_access_tokens_path
  end
end

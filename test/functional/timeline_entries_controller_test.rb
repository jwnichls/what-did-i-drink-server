require 'test_helper'

class TimelineEntriesControllerTest < ActionController::TestCase
  setup do
    @timeline_entry = timeline_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:timeline_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create timeline_entry" do
    assert_difference('TimelineEntry.count') do
      post :create, timeline_entry: { description: @timeline_entry.description, drink_id: @timeline_entry.drink_id, type: @timeline_entry.type, user_id: @timeline_entry.user_id }
    end

    assert_redirected_to timeline_entry_path(assigns(:timeline_entry))
  end

  test "should show timeline_entry" do
    get :show, id: @timeline_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @timeline_entry
    assert_response :success
  end

  test "should update timeline_entry" do
    put :update, id: @timeline_entry, timeline_entry: { description: @timeline_entry.description, drink_id: @timeline_entry.drink_id, type: @timeline_entry.type, user_id: @timeline_entry.user_id }
    assert_redirected_to timeline_entry_path(assigns(:timeline_entry))
  end

  test "should destroy timeline_entry" do
    assert_difference('TimelineEntry.count', -1) do
      delete :destroy, id: @timeline_entry
    end

    assert_redirected_to timeline_entries_path
  end
end

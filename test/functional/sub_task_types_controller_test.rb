require 'test_helper'

class SubTaskTypesControllerTest < ActionController::TestCase
  setup do
    @sub_task_type = sub_task_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sub_task_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sub_task_type" do
    assert_difference('SubTaskType.count') do
      post :create, sub_task_type: {  }
    end

    assert_redirected_to sub_task_type_path(assigns(:sub_task_type))
  end

  test "should show sub_task_type" do
    get :show, id: @sub_task_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sub_task_type
    assert_response :success
  end

  test "should update sub_task_type" do
    put :update, id: @sub_task_type, sub_task_type: {  }
    assert_redirected_to sub_task_type_path(assigns(:sub_task_type))
  end

  test "should destroy sub_task_type" do
    assert_difference('SubTaskType.count', -1) do
      delete :destroy, id: @sub_task_type
    end

    assert_redirected_to sub_task_types_path
  end
end

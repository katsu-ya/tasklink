require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should redirect when not logged in" do
    sign_out @user

    get tasks_url
    assert_response :redirect
  end

  test "should create task" do
    assert_difference("Task.count", 1) do
      post tasks_url, params: {
      task: {
      title: "New Task",
      status: :todo
      }
    }
  end

  assert_redirected_to tasks_path
end

  test "should destroy task" do
    task = Task.create!(
      title: "Delete Me",
      user: @user,
      status: :todo
    )

  assert_difference("Task.count", -1) do
    delete task_url(task)
  end
  end
end

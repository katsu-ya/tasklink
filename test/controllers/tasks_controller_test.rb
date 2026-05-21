require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user

    @task = @user.tasks.create!(
      title: "Old Task",
      status: "todo"
    )
  end

  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should redirect when not logged in" do
    sign_out @user

    get tasks_url
    assert_redirected_to new_user_session_path
  end

  test "should create task" do
    assert_difference("Task.count") do
      post tasks_url, params: {
        task: {
          title: "New Task",
          status: "todo"
        }
      }
    end

    assert_redirected_to tasks_path
  end

  test "should destroy task" do
    assert_difference("Task.count", -1) do
      delete task_url(@task)
    end

    assert_redirected_to tasks_path
  end

  test "should update task" do
    patch task_url(@task), params: {
      task: {
        title: "Updated Task"
      }
    }

    assert_redirected_to tasks_path
    @task.reload
    assert_equal "Updated Task", @task.title
  end

  test "should not update task with invalid params" do
    patch task_url(@task), params: {
      task: {
        title: nil
      }
    }

    @task.reload
    assert_equal "Old Task", @task.title
  end

  test "should not access other user's task" do
  sign_in users(:one)

  other_task = users(:two).tasks.create!(
    title: "Other Task",
    status: "todo",
    user: users(:two)
  )

  patch task_url(other_task), params: {
    task: {
      title: "Hacked"
    }
  }

  assert_response :not_found
end
end

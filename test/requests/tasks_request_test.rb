require "test_helper"

class TasksRequestTest < ActionDispatch::IntegrationTest
setup do
@user = User.create!(
email: "test@example.com",
password: "password123",
password_confirmation: "password123"
)

@other_user = User.create!(
  email: "other@example.com",
  password: "password123",
  password_confirmation: "password123"
)

sign_in @user
end

test "can search tasks" do
@user.tasks.create!(
title: "Rails Task",
status: "todo"
)

@user.tasks.create!(
  title: "React Task",
  status: "todo"
)

get tasks_path, params: {
  keyword: "Rails"
}

assert_response :success
assert_match "Rails Task", response.body
assert_no_match "React Task", response.body
end

test "cannot access other user's task" do
other_task = @other_user.tasks.create!(
title: "Secret Task",
status: "todo"
)

patch task_path(other_task), params: {
  task: {
    title: "Hacked"
  }
}

assert_response :not_found
end

test "redirects when not logged in" do
sign_out @user

get tasks_path

assert_response :redirect
end

test "can create task" do
assert_difference("Task.count", 1) do
post tasks_path, params: {
task: {
title: "Request Test Task",
status: "todo"
}
}
end

assert_response :redirect
end

test "cannot create invalid task" do
assert_no_difference("Task.count") do
post tasks_path, params: {
task: {
title: "",
status: "todo"
}
}
end
end

test "can update task" do
task = @user.tasks.create!(
title: "Old Title",
status: "todo"
)

patch task_path(task), params: {
  task: {
    title: "New Title"
  }
}

assert_equal "New Title", task.reload.title
end

test "can destroy task" do
task = @user.tasks.create!(
title: "Delete Me",
status: "todo"
)

assert_difference("Task.count", -1) do
  delete task_path(task)
end
end

test "can filter todo tasks" do
@user.tasks.create!(
title: "Todo Task",
status: "todo"
)

@user.tasks.create!(
  title: "Done Task",
  status: "done"
)

get tasks_path, params: {
  status: "todo"
}

assert_response :success
assert_match "Todo Task", response.body
assert_no_match "Done Task", response.body
end

test "can filter done tasks" do
@user.tasks.create!(
title: "Todo Task",
status: "todo"
)

@user.tasks.create!(
  title: "Done Task",
  status: "done"
)

get tasks_path, params: {
  status: "done"
}

assert_response :success
assert_match "Done Task", response.body
assert_no_match "Todo Task", response.body
end

test "can search with keyword and status filter" do
@user.tasks.create!(
title: "Rails Todo",
status: "todo"
)

@user.tasks.create!(
  title: "Rails Done",
  status: "done"
)

get tasks_path, params: {
  keyword: "Rails",
  status: "todo"
}

assert_response :success
assert_match "Rails Todo", response.body
assert_no_match "Rails Done", response.body
end

test "cannot update task with invalid params" do
  task = @user.tasks.create!(
    title: "Old Task",
    status: "todo"
  )

  patch task_path(task), params: {
    task: {
      title: ""
    }
  }

  task.reload
  assert_equal "Old Task", task.title
end

test "progress does not become NaN when no tasks exist" do
  @user.tasks.destroy_all

  get tasks_path

  assert_response :success
  assert_match "0%", response.body
end

test "can search by japanese status keyword" do
  @user.tasks.create!(
    title: "Task 1",
    status: "doing"
  )

  get tasks_path, params: {
    keyword: "作業中"
  }

  assert_response :success
  assert_match "Task 1", response.body
end

test "can filter doing tasks" do
  @user.tasks.create!(
    title: "Doing Task",
    status: "doing"
  )

  @user.tasks.create!(
    title: "Done Task",
    status: "done"
  )

  get tasks_path, params: {
    status: "doing"
  }

  assert_response :success
  assert_match "Doing Task", response.body
  assert_no_match "Done Task", response.body
end

test "can update task status to done" do
  task = @user.tasks.create!(
    title: "Progress Task",
    status: "doing"
  )

  patch task_path(task), params: {
    task: {
      status: "done"
    }
  }

  assert_equal "done", task.reload.status
end

test "can create task with deadline" do
  assert_difference("Task.count", 1) do
    post tasks_path, params: {
      task: {
        title: "Deadline Task",
        status: "todo",
        deadline: Date.tomorrow
      }
    }
  end

  assert_response :redirect
end

test "search returns empty result" do
  @user.tasks.create!(
    title: "Rails Task",
    status: "todo"
  )

  get tasks_path, params: {
    keyword: "Vue"
  }

  assert_response :success
  assert_no_match "Rails Task", response.body
end

test "status all returns every task" do
  @user.tasks.create!(
    title: "Todo Task",
    status: "todo"
  )

  @user.tasks.create!(
    title: "Done Task",
    status: "done"
  )

  get tasks_path, params: {
    status: "all"
  }

  assert_response :success
  assert_match "Todo Task", response.body
  assert_match "Done Task", response.body
end

test "can update task to doing" do
  task = @user.tasks.create!(
    title: "Task",
    status: "todo"
  )

  patch task_path(task), params: {
    task: {
      status: "doing"
    }
  }

  assert_equal "doing", task.reload.status
end

test "can access new page" do
  get new_task_path

  assert_response :success
end

test "can access edit page" do
  task = @user.tasks.create!(
    title: "Edit Task",
    status: "todo"
  )

  get edit_task_path(task)

  assert_response :success
end

test "invalid create renders new" do
  post tasks_path, params: {
    task: {
      title: nil,
      status: "todo"
    }
  }

  assert_response :success
end

test "invalid update does not change task" do
  task = @user.tasks.create!(
    title: "Original",
    status: "todo"
  )

  patch task_path(task), params: {
    task: {
      title: nil
    }
  }

  task.reload
  assert_equal "Original", task.title
end


test "search by 完了 keyword" do
  @user.tasks.create!(
    title: "Completed Task",
    status: "done"
  )

  get tasks_path, params: {
    keyword: "完了"
  }

  assert_response :success
  assert_match "Completed Task", response.body
end
end

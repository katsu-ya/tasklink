# spec/requests/tasks_spec.rb

require "rails_helper"

RSpec.describe "Tasks", type: :request do
  around do |example|
    Bullet.enable = false
    example.run
    Bullet.enable = true
  end

  describe "GET /tasks" do
    it "returns http success" do
      user = create(:user)

      sign_in user

      get root_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /tasks" do
    it "creates a task" do
      user = create(:user)

      sign_in user

      expect do
        post tasks_path, params: {
          task: {
            title: "RSpec Task",
            description: "Test Description"
          }
        }
      end.to change(Task, :count).by(1)

      expect(response).to redirect_to(tasks_path)
    end

describe "PATCH /tasks/:id" do
  it "updates a task" do
    user = create(:user)
    task = create(:task, user: user)

    sign_in user

    patch task_path(task), params: {
      task: {
        title: "Updated Task"
      }
    }

    expect(task.reload.title).to eq("Updated Task")
    expect(response).to redirect_to(tasks_path)
  end
end

describe "DELETE /tasks/:id" do
  it "deletes a task" do
    user = create(:user)
    task = create(:task, user: user)

    sign_in user

    expect do
      delete task_path(task)
    end.to change(Task, :count).by(-1)

    expect(response).to redirect_to(tasks_path)
  end
end

describe "when not signed in" do
  it "redirects to login page" do
    get root_path

    expect(response).to redirect_to(new_user_session_path)
  end
end


describe "POST /tasks" do
  it "does not create a task without title" do
    user = create(:user)

    sign_in user

    expect do
      post tasks_path, params: {
        task: {
          title: "",
          description: "Invalid Task"
        }
      }
    end.not_to change(Task, :count)

    expect(response).to have_http_status(:ok)
  end
end

describe "PATCH /tasks/:id" do
it "updates a task" do
user = create(:user)
task = create(:task, user: user, title: "Old Title")

sign_in user

patch task_path(task), params: {
  task: {
    title: "New Title"
  }
}

expect(response).to redirect_to(tasks_path)
expect(task.reload.title).to eq("New Title")

end

it "does not update with invalid params" do
user = create(:user)
task = create(:task, user: user, title: "Old Title")

sign_in user

patch task_path(task), params: {
  task: {
    title: nil
  }
}

expect(task.reload.title).to eq("Old Title")
expect(response).to have_http_status(:unprocessable_content)

end
end

describe "DELETE /tasks/:id" do
it "deletes a task" do
user = create(:user)
task = create(:task, user: user)

sign_in user

expect do
  delete task_path(task)
end.to change(Task, :count).by(-1)

expect(response).to redirect_to(tasks_path)

end
end


describe "GET /tasks search" do
it "filters tasks by keyword" do
user = create(:user)

create(:task, user: user, title: "Buy milk")
create(:task, user: user, title: "Workout")

sign_in user

get tasks_path, params: {
  keyword: "milk"
}

expect(response.body).to include("Buy milk")
expect(response.body).not_to include("Workout")

end
end



describe "PATCH /tasks/:id status update" do
it "updates task status" do
user = create(:user)
task = create(:task, user: user, status: "todo")

sign_in user

patch task_path(task), params: {
  task: {
    status: "doing"
  }
}

expect(response).to redirect_to(tasks_path)
expect(task.reload.status).to eq("doing")

end
end

describe "search/filter" do
  it "filters tasks by status" do
  user = create(:user)

  create(:task, title: "Todo task", status: "todo", user: user)
  done_task = create(:task, title: "Done task", status: "done", user: user)

  sign_in user

  get tasks_path, params: { status: "done" }

  expect(response).to have_http_status(:success)
  expect(response.body).to include(done_task.title)
end
end

it "searches task by keyword" do
  user = create(:user)

  task1 = create(:task, user: user, title: "買い物")
  task2 = create(:task, user: user, title: "勉強")

  sign_in user

  get tasks_path, params: { keyword: "買い" }

  expect(response.body).to include(task1.title)
  expect(response.body).not_to include(task2.title)
end


describe "GET /tasks/:id/edit" do
it "returns http success" do
user = create(:user)
task = create(:task, user: user)

sign_in user

get edit_task_path(task)

expect(response).to have_http_status(:success)

end
end


describe "authorization" do
it "does not allow another user's task to be updated" do
user = create(:user)
other_user = create(:user)

task = create(:task,
              user: other_user,
              title: "Original Title")

sign_in user

patch task_path(task), params: {
  task: {
    title: "Hacked Title"
  }
}

task.reload

expect(task.title).to eq("Original Title")

end
end

describe "GET /tasks/new" do
it "returns http success" do
user = create(:user)
sign_in user

get new_task_path

expect(response).to have_http_status(:success)

end
end

describe "GET /tasks/:id/edit" do
it "returns http success" do
user = create(:user)
task = create(:task, user: user)

sign_in user

get edit_task_path(task)

expect(response).to have_http_status(:success)

end
end

describe "PATCH /tasks/:id" do
  it "updates task status" do
    user = create(:user)
    task = create(:task, user: user, status: "todo")

    sign_in user

    patch task_path(task), params: {
      task: { status: "done" }
    }

    expect(task.reload.status).to eq("done")
  end
end


describe "authentication" do
it "redirects to login when accessing new without sign in" do
get new_task_path

expect(response).to redirect_to(new_user_session_path)

end

it "redirects to login when creating task without sign in" do
post tasks_path, params: {
task: {
title: "Unauthorized Task"
}
}

expect(response).to redirect_to(new_user_session_path)

end

it "redirects to login when editing task without sign in" do
task = create(:task)

get edit_task_path(task)

expect(response).to redirect_to(new_user_session_path)

end
end

  end
end

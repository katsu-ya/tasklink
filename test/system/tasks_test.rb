require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase

  def login(user)
  visit new_user_session_path

  fill_in "メールアドレス", with: user.email
  find("input[name='user[password]']").set("password123")

  click_button "ログイン"

  assert_text "タスク一覧"
end


  test "user can create task" do
  user = User.create!(
    email: "system#{SecureRandom.hex(4)}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )

  login(user)

  click_link "＋ 新規投稿"

  find("input[name='task[title]']").set("System Test Task")

  click_button "投稿"

  visit tasks_path

  assert_text "System Test Task"
end




  test "user can delete task" do
  user = User.create!(
    email: "system#{SecureRandom.hex(4)}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )

  user.tasks.create!(
    title: "Delete Me",
    status: "todo"
  )

  login(user)

  assert_text "Delete Me"

  accept_confirm do
    within("#tasks") do
      first("a[data-turbo-method='delete']").click
    end
  end

  assert_no_selector "h2", text: "Delete Me"
end



  test "user can update task status" do
  user = User.create!(
    email: "system#{SecureRandom.hex(4)}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )

  user.tasks.create!(
    title: "Status Task",
    status: "todo"
  )

  login(user)

  first("input[value='▶ ステータス変更']").click

  assert_text "🔥 作業中"
end
end

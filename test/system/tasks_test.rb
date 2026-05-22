require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  test "user can create task" do
    user = users(:one)

    visit new_user_session_path

    fill_in "メールアドレス", with: user.email
    fill_in "password_field", with: "password123"

    click_button "ログイン"

    assert_text "タスク一覧"

    click_link "＋ 新規投稿"

    fill_in "Title", with: "System Test Task"

    click_button "投稿"

    assert_text "System Test Task"
  end
end

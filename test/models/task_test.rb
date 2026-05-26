require "test_helper"

class TaskTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "task_test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end
  
  test "is valid with title and user" do
    user = User.create!(
      email: "task@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    task = Task.new(
      title: "Test Task",
      user: user,
      status: "todo"
    )

    assert task.valid?
  end

  test "is invalid without title" do
    user = User.create!(
      email: "task2@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    task = Task.new(
      title: nil,
      user: user
    )

    assert_not task.valid?
  end

  test "is invalid without user" do
    task = Task.new(
      title: "Test Task"
    )

    assert_not task.valid?
  end

  test "status enum works" do
    user = User.create!(
      email: "task3@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    task = Task.create!(
      title: "Enum Test",
      user: user,
      status: "doing"
    )

    assert task.doing?
  end

  test "team is optional" do
    user = User.create!(
      email: "task4@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    task = Task.new(
      title: "Optional Team",
      user: user,
      status: "todo"
    )

    assert task.valid?
  end

  test "deadline can be blank" do
  task = Task.new(
    title: "No deadline task",
    status: "todo",
    user: @user,
    deadline: nil
  )

  assert task.valid?
end

test "task can have future deadline" do
  task = Task.new(
    title: "Future task",
    status: "todo",
    user: @user,
    deadline: Date.tomorrow
  )

  assert task.valid?
end

test "task can have past deadline" do
  task = Task.new(
    title: "Expired task",
    status: "todo",
    user: @user,
    deadline: Date.yesterday
  )

  assert task.valid?
end
end

require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "task is valid with title" do
    task = Task.new(
      title: "Study Rails",
      user: users(:one)
    )

    assert task.valid?
  end

  test "task is invalid without title" do
    task = Task.new(
      title: nil,
      user: users(:one)
    )

    assert_not task.valid?
   end

  test "task is invalid without user" do
    task = Task.new(
      title: "Study Rails",
      user: nil
    )

    assert_not task.valid?
  end

  test "task status can be todo" do
    task = Task.new(
      title: "Study Rails",
      user: users(:one),
      status: :todo
    )

    assert task.valid?
  end

  test "task status can be doing" do
    task = Task.new(
      title: "Study Rails",
      user: users(:one),
      status: :doing
    )

    assert task.valid?
  end

  test "task status can be done" do
    task = Task.new(
      title: "Study Rails",
      user: users(:one),
      status: :done
    )

    assert task.valid?
  end

  test "task is valid without team" do
    task = Task.new(
      title: "Study Rails",
      user: users(:one),
      team: nil
    )

    assert task.valid?
  end
end

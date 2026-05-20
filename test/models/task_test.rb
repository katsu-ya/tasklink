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
end



require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is valid with email and password" do
    user = User.new(
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.valid?
  end

  test "is invalid without email" do
    user = User.new(
      email: nil,
      password: "password123"
    )

    assert_not user.valid?
  end

  test "is invalid with duplicate email" do
    User.create!(
      email: "duplicate@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    user = User.new(
      email: "duplicate@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not user.valid?
  end
end

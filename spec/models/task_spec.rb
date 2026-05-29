require "rails_helper"

RSpec.describe Task, type: :model do
  it "is valid with a title" do
    user = User.new(
      email: "test@example.com",
      password: "password123"
    )

    task = Task.new(
      title: "RSpec test",
      user: user
    )

    expect(task).to be_valid
  end
end

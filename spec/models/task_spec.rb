require "rails_helper"

RSpec.describe Task, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      task = build(:task)

      expect(task).to be_valid
    end

    it "is invalid without a title" do
      task = build(:task, title: nil)

      expect(task).not_to be_valid
      expect(task.errors[:title]).to include("can't be blank")
    end

    it "is invalid with too long title" do
  task = build(:task, title: "a" * 101)

  expect(task).not_to be_valid
end

it "is valid with title under limit" do
  task = build(:task, title: "a" * 100)

  expect(task).to be_valid
end

    it "belongs to a user" do
      task = build(:task, user: nil)

      expect(task).not_to be_valid
    end
  end

  describe "status" do
    it "can have todo status" do
      task = build(:task, status: "todo")

      expect(task).to be_valid
    end

    it "can have doing status" do
      task = build(:task, status: "doing")

      expect(task).to be_valid
    end

    it "can have done status" do
      task = build(:task, status: "done")

      expect(task).to be_valid
    end
  end
end

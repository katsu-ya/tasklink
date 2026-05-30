require "rails_helper"

RSpec.describe Task, type: :model do
  it "is valid with a title" do
    task = build(:task)
    expect(task).to be_valid
  end
end

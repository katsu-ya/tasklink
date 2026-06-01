FactoryBot.define do
  factory :task do
    title { "RSpec task" }
    association :user
  end
end

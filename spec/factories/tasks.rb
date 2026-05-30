FactoryBot.define do
  factory :task do
    title { "RSpec task" }
    description { "test description" }
    status { :doing }
    association :user
  end
end

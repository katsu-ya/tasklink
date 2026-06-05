FactoryBot.define do
  factory :task do
    title { "Task" }
    description { "Sample" }
    status { "todo" }

    user
    team { user&.team }
  end
end

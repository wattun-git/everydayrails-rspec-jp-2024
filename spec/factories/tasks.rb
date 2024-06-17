FactoryBot.define do
  factory :task do
    association :project
    name {"Test task"}
  end
end

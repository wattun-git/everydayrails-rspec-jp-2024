FactoryBot.define do
  factory :task do
    name { "My important task." }
    association :project
  end
end
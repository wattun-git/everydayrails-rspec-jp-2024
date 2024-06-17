FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name { "Aaron" }
    last_name  { "Sumner" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "dottle-nouveau-pavilion-tights-furze" }

    trait :with_projects do
      after(:create) { |user| create_list(:project, 2, owner: user)}
    end
  end
end

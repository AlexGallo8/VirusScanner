FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "Password123!" }
    password_confirmation { "Password123!" }
    auth_provider { 'local' }

    trait :with_test_email do
      email { "test.user@example.com" }
    end
  end
end
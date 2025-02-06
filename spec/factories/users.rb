FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    username { Faker::Internet.unique.username }
    password { "Password123!" }
    password_confirmation { "Password123!" }
    auth_provider { 'local' }
  end
end
FactoryBot.define do
  factory :scan do
    file_name { "test_file.pdf" }
    file_size { 1024 }
    file_type { "application/pdf" }
    hashcode { Faker::Crypto.sha256 }
    upload_date { Time.current }
    association :user

    trait :with_results do
      after(:create) do |scan|
        scan.results = {
          'engine1' => { 'category' => 'malicious' },
          'engine2' => { 'category' => 'undetected' }
        }
      end
    end
  end
end
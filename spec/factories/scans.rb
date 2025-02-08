FactoryBot.define do
  factory :scan do
    sequence(:hashcode) { |n| "test_hashcode_#{n}" }
    file_name { "test_file.pdf" }

    trait :with_result do
      scan_result do
        {
          'engine1' => {
            'category' => 'malicious',
            'method' => 'static',
            'result' => 'detected'
          },
          'engine2' => {
            'category' => 'undetected',
            'method' => 'dynamic',
            'result' => 'clean'
          }
        }
      end
    end
  end
end
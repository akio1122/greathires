FactoryGirl.define do
  factory :invitation do
    first { "John" }
    last  { "Doe" }
    sequence(:email) { |n| "test#{n}@example.com" }
    account
  end
end

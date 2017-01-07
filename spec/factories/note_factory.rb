FactoryGirl.define do
  factory :note do
    text { Faker::Lorem.sentence }
  end
end
FactoryGirl.define do
  factory :job_specification, class: JobSpecification do
    text {Faker::Lorem.sentence}
  end
end
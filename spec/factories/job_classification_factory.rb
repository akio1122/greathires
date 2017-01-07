FactoryGirl.define do

  factory :business_unit, class: JobClassification do
    name { "Business units" }
  end

  factory :job_function, class: JobClassification do
    name { "Job Functions" }
  end

  factory :job_level, class: JobClassification do
    name { "Job Level" }
  end

  factory :job_position, class: JobClassification do
    name { "Job Positions" }
  end

end
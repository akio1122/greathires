FactoryGirl.define do
  factory :job_interviewer do
    scheduled_on { "01/01/2013" }
    location {"Dallas/Fort Worth Area"}
    office_phone { '12345678' }
    length {45}
    is_break {false}
  end
end

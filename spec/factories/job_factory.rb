FactoryGirl.define do
  factory :job, class: Job do
    name {"Alliance Manager"}
    requisition_ref {"Round One"}
    #~ account_position { FactoryGirl.build :account_position_1 }
    #~ account_level { FactoryGirl.build :account_level_1 }
    #~ account_function { FactoryGirl.build :account_function_1 }
    # rating_scale { FactoryGirl.build :rating_scale_overall }
    account
    active { true }
    description {"Come join Intuit as part of the Small Business Partner Solutions team as an Alliance Specialist. We are looking for creative problem solvers with a passion for innovation to join our team and revolutionize the way the world does business."}
    video_url {'http://www.youtube.com/watch?v=PYYBCRpGtm8'}
    video_description {'Description of the video goes here'}
  end
end
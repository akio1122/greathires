FactoryGirl.define do
  factory :account do
    company_name { Faker::Name.name }
    email_domain { Faker::Internet.domain_name }
    active { true }
  end

  factory :account1, class: Account do
    is_template true
    company_name{'Account 1' }
    email_domain { Faker::Internet.domain_name }
    active { true }
    classification_options_attributes {[
      {name: "Job Functions",
       job_classifications_attributes: [{name: "Customer Service & Support"}, {name: "Data"}]
      },
      {name: "Job Positions",
       job_classifications_attributes: [{name: "Sample Position 1"}, {name: "Sample Position 2"}]
      },
      {name: "Job Levels",
       job_classifications_attributes: [{name: "Intern"}, {name: "Co-op"}, {name: "Associate"}, {name: "Manager"}]
      }
    ]}
    #functions_attributes { [{name: "Customer Service & Support"}, {name: "Data"}] }
    #positions_attributes { [{name: "Sample Position 1"}, {name: "Sample Position 2"}] }
    #levels_attributes { [{name: "Intern"}, {name: "Co-op"}, {name: "Associate"}, {name: "Manager"}] }
    skills_attributes { [{name: "Teamwork"}, {name: "Leadership"}, {name: "Communication"}] }
    specification_sections_attributes { [{name: "Required Skills"}, {name: "Desired Skills"}] }
    interview_rounds_attributes { [{name: 'Resume Screen'}, {name: 'Phone Screen'}, {name: 'First Round'}] }
    roles_attributes { [{name: 'Job Manager'}, {name: 'Interviewer'}, {name: 'Candidate'}] }
    rating_scales_attributes { [{name: "Thumbs Up", handle: 'like', is_for_traits: true}, {name: "Foobar", handle: 'acceptance', is_for_traits: true}] }

    after(:create) do |account, evaluator|
      FactoryGirl.create(:permission_read_account)
      FactoryGirl.create(:permission_create_account)
      FactoryGirl.create(:permission_update_account)
      FactoryGirl.create(:permission_read_job)
      FactoryGirl.create(:permission_create_job)
      FactoryGirl.create(:permission_update_job)
      FactoryGirl.create(:permission_create_hr_note)
      FactoryGirl.create(:role_account_manager, account: account)
      FactoryGirl.create(:role_account_user, account: account)
      FactoryGirl.create(:role_hiring_manager, account: account)
    end
    
  end
  
end

FactoryGirl.define do

  factory :role_account_manager, class: Role do
    
    name { 'Account Manager' }
    
    after(:create) do |role, evaluator|
      role.set_permission_value(:read_account, true)
      role.set_permission_value(:update_account, true)
      role.set_permission_value(:read_job, true)
      role.set_permission_value(:create_job, true)
      role.set_permission_value(:update_job, true)
    end

  end

  factory :role_account_user, class: Role do
    
    name { 'Account User' }
    
    after(:create) do |role, evaluator|
      role.set_permission_value(:read_account, true)
    end

  end

  factory :role_account_job_manager, class: Role do
    
    name { 'Account Job Manager' }
    
    after(:create) do |role, evaluator|
      role.set_permission_value(:read_account, true)
      role.set_permission_value(:create_job, true)
    end

  end

  factory :role_hiring_manager, class: Role do

    name { 'Hiring Manager' }

    after(:create) do |role, evaluator|
      role.set_permission_value(:read_account, true)
      role.set_permission_value(:read_job, true)
      role.set_permission_value(:update_job, true)

      role.set_permission_value(:create_hr_notes, true)
    end

  end

  factory :role_talent_manager, class: Role do

    name { 'Hiring Manager' }

    after(:create) do |role, evaluator|
      role.set_permission_value(:read_account, true)
      role.set_permission_value(:read_job, true)
    end

  end

end
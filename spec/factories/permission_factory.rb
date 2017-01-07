FactoryGirl.define do

  factory :permission_read_account, class: Permission do
    action { :read_account }
    description { 'Read Account' }
    kind { :account }
  end

  factory :permission_create_account, class: Permission do
    action { :create_account }
    description { 'Create Account' }
    kind { :account }
  end

  factory :permission_update_account, class: Permission do
    action { :update_account }
    description { 'Update Account' }
    kind { :account }
  end

  factory :permission_read_job, class: Permission do
    action { :read_job }
    description { 'Read Job' }
    kind { :job }
  end

  factory :permission_create_job, class: Permission do
    action { :create_job }
    description { 'Create Job' }
    kind { :account }
  end

  factory :permission_update_job, class: Permission do
    action { :update_job }
    description { 'Update Job' }
    kind { :job }
  end

  factory :permission_create_hr_note, class: Permission do
    action { :create_hr_notes }
    description { 'Can add Hiring Manager Notes' }
    kind { :job }
  end
end
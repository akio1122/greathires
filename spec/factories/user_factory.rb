FactoryGirl.define do
  trait :basic_fields do
    email { Faker::Internet.email }
    first { Faker::Name.first_name }
    last { Faker::Name.last_name }
    password { "pass123" }
    password_confirmation { "pass123" }
    time_zone
  end

  trait :time_zone do
    time_zone { ActiveSupport::TimeZone.us_zones.map(&:name).sample }
  end

  factory :user, class: User do
    basic_fields
  end

  factory :user_sysadmin, class: User do
    basic_fields
    email { 'admin@greathires.co' }
    first { 'System' }
    last { 'Administrator' }
    is_superuser { true }
    after(:create) do |user, evaluator|
      user.make_current
    end
  end

  factory :user_account_manager, class: User do
    basic_fields
    ignore do
      account true
    end
    after(:create) do |user, evaluator|
      evaluator.account.user_roles.create(user: user, role: Role.account_manager)
    end
  end

  factory :user_account_user, class: User do
    basic_fields
    ignore do
      account true
    end
    after(:create) do |user, evaluator|
      if evaluator.account
        evaluator.account.user_roles.create(user: user, role: Role.account_user)
      end
    end
  end

  factory :user_talent_manager, class: User do
    basic_fields
  end

  factory :user_hiring_manager, class: User do
    basic_fields
    ignore do
      account true
      job true
    end
    after(:create) do |user, evaluator|
      account = evaluator.account
      account.user_roles.create(user: user, role: account.hiring_manager_role, job: evaluator.job) if account
     end
  end

  factory :user_interviewer, class: User do
    basic_fields
  end
end

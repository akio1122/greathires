require "rails_helper"

describe Account do
  subject { FactoryGirl.create(:account) }

  it_behaves_like "an accountable model"

  it "uses the company name to construct a slug" do
  end

  context "santizers" do
    [
      :company_name, :email_domain, :preferred_candidate_label,
      :overall_questions_title, :overall_comments_label,
      :overall_comments_message, :view_job_skills_comments_message,
      :job_skills_label
    ].each do |attribute|
      it "normalizes #{attribute}" do
        expect(subject).to normalize_attribute(attribute)
      end
    end
  end

  context "associations" do
    specify { expect(subject).to belong_to(:owner) }
    specify { expect(subject).to belong_to(:plan) }
    specify { expect(subject).to have_many(:role_permissions).through(:roles) }
    specify { expect(subject).to have_many(:interview_guides).through(:jobs)  }
    specify { expect(subject).to have_many(:users).through(:user_roles) }

    [
      :classifications, :roles, :hiring_team_roles, :skills, :specifications,
      :interview_rounds, :interview_types, :statuses, :rating_scales,
      :priorities, :jobs, :candidates, :user_roles, :invitations,
      :email_templates
    ].each do |relation|
      specify { expect(subject).to have_many(relation) }
    end

    specify do
      expect(subject).to have_many(:rating_scale_options).through(:rating_scales)
    end

    specify do
      pending
      expect(subject).to(
        have_many(:interview_account_managers).class_name('Invitation')
      )
    end

    specify do
      pending
      expect(subject).to(
        have_many(:candidate_priorities).class_name('Priority')
      )
    end

    [:candidate, :interview, :job].each do |relation|
      specify do
        pending
        expect(subject).to(
          have_many("#{relation}_statuses").
            class_name('Status').
            conditions(typeof: relation.to_s)
        )
      end
    end
  end

  context "validations" do
    specify { expect(subject).to validate_presence_of(:company_name) }

    it "requires a valid company email address" do
      expect(subject).to allow_value('example.com').for(:email_domain)
      expect(subject).to_not allow_value('foo@test.com').for(:email_domain)
    end
  end
end

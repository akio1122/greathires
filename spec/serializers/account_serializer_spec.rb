require "rails_helper"

describe AccountSerializer do
  let(:properties) do
    [:active, :company_name, :company_email]
  end

  let(:associations) do
    [
      :roles, :user_roles, :role_permissions, :job_statuses, :candidate_statuses,
      :interview_statuses, :hiring_team_roles, :skills, :specifications
    ]
  end

  it_behaves_like "a serializer"
  it_behaves_like "a serializer that includes important properties"
  it_behaves_like "a serializer that includes associations"
end

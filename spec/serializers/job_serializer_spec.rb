require "rails_helper"

describe JobSerializer do
  let(:properties) do
    [
      :name, :description, :requisition_ref, :video_url, :video_description,
      :interview_guides_count, :personalized_interview_guides
    ]
  end

  let(:associations) do
    [
      :job_classifications, :specifications, :job_skills, :interview_guides,
      :user_roles, :status
    ]
  end

  it_behaves_like "a serializer"
  it_behaves_like "a serializer that includes important properties"
  it_behaves_like "a serializer that includes associations"
end

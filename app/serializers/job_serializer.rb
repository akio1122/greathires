class JobSerializer < ApplicationSerializer
  attributes :name, :status_id, :description, :requisition_ref, :is_template,
             :video_url, :video_description, :personalized_interview_guides,
             :interview_guides_count

  has_many :job_classifications
  has_many :specifications
  has_many :job_skills
  has_many :interview_guides
  has_many :user_roles
  has_many :job_candidates
  has_one :status

end

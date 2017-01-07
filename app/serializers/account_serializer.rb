class AccountSerializer < ApplicationSerializer
  attributes :slug,
    :active,
    :company_name,
    :email_domain,
    :interviewer_notes_enabled,
    :display_linked_in,

    :job_request_enabled,
    # evaluate settings
    :preferred_candidate_enabled,
    :preferred_candidate_label,
    :overall_questions_title,
    :overall_comments_enabled,
    :overall_comments_label,
    :overall_comments_message,
    :view_job_skills_comments_message,
    :job_skils_comments_enabled,
    # job features
    :job_video_urls_enabled,
    :job_spec_categories_label,

    :job_spec_large_text_field_type,
    :job_spec_large_text_field_rating_type,
    :job_spec_text_field_allows_sub_bullets,

    :job_spec_questions_enabled,
    :job_spec_questions_numbered,
    :job_spec_questions_text_field_type,
    :job_spec_questions_text_field_rating_type,
    # interview guide
    :personalized_interview_guides_enabled,
    :job_skills_label,
    :job_skill_traits_ratable,
    :job_skill_traits_rating_type,
    :job_skill_sub_traits_enabled,

    :job_skill_questions_enabled,
    :job_skill_questions_numbered,
    :job_skill_questions_ratable,
    :job_skill_questions_rating_type,
    :job_skill_questions_comments_enabled,

    :shared_comments_enabled,

    :attachnents_enabled,
    # social accounts for candidate profile
    :facebook_association_enabled,
    :twitter_association_enabled,
    :github_association_enabled

  has_many :roles
  has_many :user_roles
  has_many :role_permissions
  has_many :job_statuses
  has_many :candidate_statuses
  has_many :interview_statuses
  has_many :hiring_team_roles
  has_many :skills
  has_many :specifications
  has_many :rating_scale_options
end

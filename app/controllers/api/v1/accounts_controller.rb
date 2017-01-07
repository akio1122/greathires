class Api::V1::AccountsController < ApiController

  # Account index can call can obey an active/inactive flag
  has_scope :active_for_user, if: !:active
  has_scope :active, as: :active, default: false, only: [:index] do |controlller, scope, value|
    value == "all" ? scope : value.to_bool ? scope.active : scope.inactive
  end

  before_filter :find_resource, only: [:show, :update, :destroy]
  before_filter :authorize_updates, only: [:update, :destroy]

  PERMITTED = [:active, :company_name, :email_domain,
                :interviewer_notes_enabled, :display_linked_in,  :job_request_enabled, :shared_comments_enabled,
                # evaluate settings
                :preferred_candidate_enabled, :preferred_candidate_label,
                :overall_questions_title,  :overall_comments_enabled,
                :overall_comments_label, :overall_comments_message,
                :job_skils_comments_enabled, :view_job_skills_comments_message,
                # job features
                :job_video_urls_enabled, :job_spec_categories_label, :job_spec_large_text_field_type, :job_spec_large_text_field_rating_type, :job_spec_text_field_allows_sub_bullets,

                :job_spec_questions_enabled, :job_spec_questions_numbered, :job_spec_questions_text_field_type, :job_spec_questions_text_field_rating_type,
                # interview guide
                :personalized_interview_guides_enabled,
                :job_skills_label, :job_skill_traits_ratable, :job_skill_traits_rating_type, :job_skill_sub_traits_enabled, :job_skill_questions_ratable,
                :job_skill_questions_enabled, :job_skill_questions_numbered, :job_skill_questions_rating_type, :job_skill_questions_comments_enabled, :attachnents_enabled,
                :facebook_association_enabled, :twitter_association_enabled, :github_association_enabled
                ]

  JSON_CLASSNAME = :account

  def index
    authorize! :read_account, nil  #User must have global ability to view list of accounts.
    @resources = api_scopes(controller_name.classify.constantize, associations)

    #render_resource @resources
  end

  def show
    authorize! :read_account, @resource
    render_resource @resource
  end

  def create
    authorize! :create_account, nil  #User must have global ability to create accounts.
    @template = Account.where(is_template: true).first!
    @resource = Account.create_account_from(@template, permitted_params)
    @resource.save ? render_resource(@resource) : render_error(@resource)
  end

  def update
    authorize! :update_account, @resource
    @resource.update_attributes(permitted_params)
    @resource.save ? render_resource(@resource) : render_error(@resource)
  end

  def destroy
    authorize! :update_account, @resource
    @resource.destroy ? render_success : render_error
  end

private
  def associations
    # TODO: hiring_team_roles
    @associations ||= [
      :roles, :specifications, :skills, :interview_statuses, :job_statuses,
      :candidate_statuses,
      :user_roles,
      { role_permissions: [:permission] }
    ]
  end
  def authorize_updates
    authorize! :update_account, @resource
  end

  def find_resource
    @resource = Account.friendly.
      includes(:role_permissions => [:permission]).
      find(params[:id])
  end
end

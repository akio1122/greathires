class Api::V1::JobsController < ApiController
  # Inherit from ApiController since Job is a top level object belonging to Account ultimately.
  # as opposed to the JobBaseController

  include AccountApiScopes  #These scopes apply to Job but not Job's descendents

  # passing ?templates=true returns only items where .is_template attribute is true
  has_scope :templates, type: :boolean, only: [:index]

  # passing ?past=true returns only jobs that are considered 'past' jobs, see model scope for details.
  # any changes to the rule of what is considered past should be made in the model's scope that supports :past API scope
  has_scope :past, type: :boolean, only: [:index]

  PERMITTED = [:name, :description, :requisition_ref, :video_url, :video_description, :is_template,
                  :business_unit_id, :level_id, :function_id, :position_id, :status_id,
                  :personalized_interview_guides, :interview_guides_count]

  JSON_CLASSNAME = :job

  before_filter :find_resource, only: [:show, :update, :destroy]

  def index
    #authorize! :read_account, Account.find(params[:account_id])
    @resources = api_scopes(
      controller_name.classify.constantize,
      associations
    )
    render_resource @resources
  end

  def show
    authorize! :read_job, @resource
    render_resource @resource
  end

  def create
    @account = Account.friendly.find(params[:account_id])
    authorize! :create_job, @account
    # @resource = @account.jobs.new(permitted_params)

    if params[:job_id].to_i > 0
      clone_job = Job.complete.find(params[:job_id])
      @resource = Job.create_from(clone_job, permitted_params)
    else
      @resource = Job.initialize_new_job(@account, permitted_params)
    end
    @resource.id.nil? ? render_error(@resource) : render_resource(@resource)
  end

private

  def find_resource
    @resource = Job.complete.find(params[:id])
    @account = Account.eager_load(:user_roles).find(@resource.account_id)
    # TODO: Lines commented out below because were sub-optimal query strategy.  Remove once determinations made that no negative impact occured.
    #@resource =  Job.eager_load(:account).eager_load(account: [:user_roles, :role_permissions]).find(params[:id])
    #@account  = @resource.account
  end

  def associations
    @associtations ||= [
      :job_classifications,
      :interview_guides,
      :user_roles,
      :status,
      { job_skills: [:job_skill_questions, :interview_guides, :job_skill_traits] },
      { specifications: [:job_specification_items, :job_specification_questions] },
    ]
  end
end

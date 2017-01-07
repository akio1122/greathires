class JobsController < ViewController
  before_filter :find_job, :except => [:index, :new, :create]

  def edit
    # This route renders a simple Rails view that loads the AngularJS-based Job Editor.
    authorize! :update_job, @job
    @preloaded = {
      account: AccountSerializer.new(@job.account, current_user: current_user, root:false),
      current_user: UserSerializer.new(current_user, root:false),
      job_roles: ActiveModel::ArraySerializer.new(
        @job.user_roles.to_a, each_serializer: UserRoleSerializer, root: false,
        current_user: current_user
      ),
      resource: JobSerializer.new(
        @job, current_user: current_user, root: false, current_user: current_user
      )
    }
  end

  def index
    # This route renders a simple Rails view that loads the AngularJS-based Job Lister.
    @account = current_account
    @preloaded = {
      account: AccountSerializer.new(@account, current_user: current_user, root:false),
      current_user: UserSerializer.new(current_user, root:false),
      job_statuses: ActiveModel::ArraySerializer.new(
        @account.job_statuses.to_a, each_serializer: StatusSerializer, root: false,
        current_user: current_user
      ),
      resources: ActiveModel::ArraySerializer.new(
        @account.jobs.to_a, each_serializer: JobSerializer, root: false,
        current_user: current_user
      ),
      urls: { resource_root: account_jobs_path }
    }
  end

  def new
    authorize! :create_job, @account
    @account = current_account
    job = Job.initialize_new_job(@account, name: "#{Date.today()}", requisition_ref: "#{Date.today()}")
    job.name = "Untitled #{job.id}"
    job.requisition_ref = "Untitled #{job.id}"
    job.save!
    redirect_to account_job_edit_path(@account.id, job.id)
  end

  def candidate_summary
    authorize! :read_job, @job
    @preloaded = {
      account: AccountSerializer.new(@job.account, current_user: current_user, root:false),
      current_user: UserSerializer.new(current_user, root:false),
      job_roles: ActiveModel::ArraySerializer.new(
        @job.user_roles.to_a, each_serializer: UserRoleSerializer, root: false,
        current_user: current_user
      ),
      resource: JobSerializer.new(
        @job, current_user: current_user, root: false, current_user: current_user
      )
    }
  end

  def create
    authorize! :create_job, @account
    @job = @account.jobs.new(params[:job])
    if @job.save
      redirect_to contextualized_jobs_edit_path(@account, @job), notice: "Job was successfully created."
    else
      render :new
    end
  end

  def destroy
    authorize! :destroy_job, @job
    @job.destroy
    redirect_to job_index_path, notice: "Job was destroyed."
  end

  private

  def find_job
    @job = Job.find(params[:job_id] || params[:id])
  end


end

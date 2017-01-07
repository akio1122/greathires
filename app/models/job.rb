class Job < ActiveRecord::Base
  # Job is a single Job in the system representing something to be hired for.
  # While it "belongs to" an Account, a Job may also be used by system-wide applications
  # that don't reate directly to an Account in the future which is why we don't call it AccountJobs
  # A Job has Interviewers and can be evaluated using the rating scale associated with the Account.
  include ARAccountability
  include CustomValidators
  include AccountScopes

  
  #Relations
  belongs_to :account
  belongs_to :classification
  belongs_to :rating_scale
  belongs_to :status
  belongs_to :creator, class_name: 'User', foreign_key: :created_by

  # Helps to determine permissions
  has_many :user_roles, class_name: 'UserRole', :dependent => :destroy, autosave: true
  has_many :roles, through: :user_roles
  
  # Data specifically related to the description of the Job.
  has_many :job_classifications, :dependent => :destroy, autosave: true
  has_many :job_skills, :dependent => :destroy, autosave: true

  # The 'shortcut' name assocations are here for convenience.  They are preferred
  # however they cause problems for nested ActiveRecordSerializers
  has_many :specifications, class_name: "JobSpecification", :dependent => :destroy, autosave: true
  has_many :skills, class_name: "JobSkill", :dependent => :destroy, autosave: true

  # Data that specifically relates to the hiring component of a Job.  
  # A Job can have JobInterviewers and JobCandidates
  has_many :job_candidates, :dependent => :destroy, autosave: true
  has_many :candidates, :through => :job_candidates
  has_many :interviews, class_name: "JobInterview"
  has_many :interview_guides, class_name: 'JobInterviewGuide', :dependent => :destroy, autosave: true

  # Declare an serialized fields
  typed_store :preferences do |p|
    p.boolean :personalized_interview_guides, default: false
    p.integer :interview_guides_count, default: 0
  end
  

  # Normalize, use the with clause to ensure data within tags is stripped.
  normalize_attributes :name, :requisition_ref, :description, :video_description,
     :with => [:strip, { :sanitize_html => { :tags => %w(a strong), :attributes => %w(href) } }, :blank]

  # Validate after normalization.  
  # Per JL, function_id, position_id, level_id no longer required to create a job.
  #validates :function_id, :position_id, :level_id, presence: {message: "is required"}
  validates :account_id, presence: true
  validates :name, presence: {message: "is required"},
                   uniqueness: {scope: [:deleted_at, :account_id], message: 'is already taken'}
  validates :requisition_ref, presence: {message: "is required"},
                              uniqueness: {scope: [:deleted_at, :account_id], message: 'is already taken'}
  
  # Validate associations only if attribute data is present and has changed.
  # This prevents these lookups when non associated attributes change, speeding commits.
  validates_associated :account, if: "!account_id.nil? && account_id_changed?", message: "not valid Account reference."
  validates_with AssociatedStatus, fields: :status, if: "!status_id.nil? && status_id_changed?"
 
  #accepts_nested_attributes_for :user_roles, allow_destroy: true
  #accepts_nested_attributes_for :job_candidates, allow_destroy: true

  # Callbacks
  before_update :set_closed_at
  #after_create :add_default_job_manager
  #before_create :set_default_status

  #scope
  scope :complete,  -> {eager_load(:specifications).eager_load(specifications: :specification).eager_load(:job_skills).eager_load(job_skills: :skill).eager_load(:job_classifications).eager_load(job_classifications: :classification)}
  scope :templates, -> {where(is_template: true)}
  scope :past, -> {where.not(closed_at: nil)}

  # Constants
  ASSOCIATIONS_FOR_CLONE = [:specifications]

  # Callbacks

  # Creates a new Job object from another account
  def self.create_from (job, params={})
    # create_ is used as the method name to be consistent with AR's create vs initialize vs new, etc
    # If caller didn't pass ing a valid job, returning nil is the signal of failure.
    return nil if job.nil?
    new_obj = job.dup(except: [:status_id], include: ASSOCIATIONS_FOR_CLONE)
    new_obj.update_attributes(params)
    new_obj.save
    new_obj
  end

  def self. initialize_new_job (for_account, params = {})
    obj = self.new({account_id: for_account.id  })
    obj.update_attributes(params)

    for_account.specifications.each do |item|
      obj.specifications.new(specification_id: item.id)
    end
    obj.save
    obj
  end

  def set_closed_at
    return if self.status.nil?

    if Rails.application.config.job_closed_status_names.include?(self.status.name)
      if self.closed_at.nil?
        self.closed_at = Time.now
      end
    else
      if !self.closed_at.nil?
        self.closed_at = nil
      end
    end
  end

  # Per Jlorance
  # Commenting out _add_default_job_manager.  This doesn't belong
  # here as its the the responsiblity of the Job model itself; but part of a workflow
  # enabled by a controller and/or better yet, a domain object to wrap the workflow.
  #def add_default_job_manager
  #  # creator is added to job managers
  #  unless account.nil? && (created_by.nil? || account.job_manager_role.nil?)
  #    user_roles.create(role: account.job_manager_role, user_id: created_by)
  #  end
  #end
  
  # Per JLorance
  # Removing this set_default_status for the same reason that
  # it doesn't belong at this layer and should better be put in a domain class/object
  # def set_default_status
  #  if status_id.nil? && !account.nil?
  #    self.status = account.job_statuses.first
  #  end
  #end

end

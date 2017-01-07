# Account is the basic object that all GreatHires service is provisioned against.
#
# All Jobs, Interviews, and Evaluations belong to an Account.
# Users participate with an account by being invited at some point in time.
class Account < ActiveRecord::Base
  include ARAccountability

  extend FriendlyId
  friendly_id :company_name, use: :slugged

  require 'store_hash_to_field'
  include StoreHashToField


  #INTERVIEW_GUIDE_FIELDS = [:label, :is_available, :ratable_large_field, :sub_traits_enabled, :enable_question_field, :ratable_question_field,
  #  :question_as_numbered, :allow_comments]

  #EVALUATE_SETTINGS_FIELDS = [:title, :enable_preferred_candidate_feature, :preferred_candidate_feature_label,:enable_overall_comments,
  #  :overall_comments_label, :display_score, :display_comments, :point_scales, :job_skill_point_scales, :overall_massage, :job_skills ]
  #
  #INVITE_SETTINGS_FIELDS = [ :email_subject, :email_body ]

  #JOB_FEATURE_FIELDS = [:allow_video_urls, :sub_specification_items_enabled, :ratable_large_field,
  #   :enable_question_field, :ratable_question_field, :question_as_numbered]

  #serialize :preferences, Hash

  #attr_serialize :interview_guide, :preferences, INTERVIEW_GUIDE_FIELDS, %w{label}
  #attr_serialize :evaluate_setting, :preferences, EVALUATE_SETTINGS_FIELDS, %w{title overall_massage job_skills}
  #attr_serialize :invite_setting, :preferences, INVITE_SETTINGS_FIELDS, %w{email_subject}
  #attr_serialize :job_features, :preferences, JOB_FEATURE_FIELDS

  typed_store :preferences do |p|
    p.boolean :job_request_enabled, default: false

    p.boolean :interviewer_notes_enabled
    p.boolean :display_linked_in
    # evaluate settings
    p.boolean :preferred_candidate_enabled, default: true
    p.string :preferred_candidate_label
    p.string :overall_questions_title, default: 'Move Forward?'
    p.boolean :overall_comments_enabled, default: true
    p.string :overall_comments_label
    p.string :overall_comments_message # evaluate_setting[:overall_massage]
    p.string :view_job_skills_comments_message # evaluate_setting[:job_skills] - message to enabled roles
    p.boolean :job_skils_comments_enabled, default: false
    # job features
    p.boolean :job_video_urls_enabled
    p.string :job_spec_categories_label, default: 'Job Requirements'

    p.string :job_spec_large_text_field_type, default: 'not-ratable'
    p.string :job_spec_large_text_field_rating_type, default: 'thumbs-up'
    p.boolean :job_spec_text_field_allows_sub_bullets, default: false

    p.boolean :job_spec_questions_enabled, default: false
    p.boolean :job_spec_questions_numbered, default: false
    p.string :job_spec_questions_text_field_type, default: 'not-ratable'
    p.string :job_spec_questions_text_field_rating_type, default: 'thumbs-up'

    # job skills features
    p.boolean :personalized_interview_guides_enabled, default: true # interview_guide[:is_available]
    p.string :job_skills_label, default: 'Job Skill' # interview_guide[:label]

    p.boolean :job_skill_traits_ratable, default: false # interview_guide[:ratable_large_field]
    p.string :job_skill_traits_rating_type, default: 'thumbs-up'
    p.boolean :job_skill_sub_traits_enabled, default: false

    p.boolean :job_skill_questions_enabled, default: false # interview_guide[:enable_question_field]
    p.boolean :job_skill_questions_ratable, default: false # interview_guide[:ratable_question_field]
    p.boolean :job_skill_questions_comments_enabled, default: false # interview_guide[:allow_comments]
    p.boolean :job_skill_questions_numbered, default: false # interview_guide[:question_as_numbered]
    p.string :job_skill_questions_rating_type, default: 'thumbs-up'
    # invite settings
    #:invite_email_subject, # TODO: move to mail_templates model
    #:invite_email_body, # TODO: move to mail_templates model
    p.boolean :shared_comments_enabled, default: false

    p.boolean :attachnents_enabled, default: true

    # social accounts for candidate profile
    p.boolean :facebook_association_enabled, default: false
    p.boolean :twitter_association_enabled, default: false
    p.boolean :github_association_enabled, default: false
  end

  normalize_attributes :company_name,
                       :email_domain,
                       :preferred_candidate_label,
                       :overall_questions_title,
                       :overall_comments_label,
                       :overall_comments_message,
                       :view_job_skills_comments_message,
                       :job_skills_label

  belongs_to :owner, class_name: User, foreign_key: :owner_id
  belongs_to :plan

  # Children below are used to help configure what an Account wants so that Jobs
  # can be established with all the right data selections.
  has_many :classifications, dependent: :destroy, autosave: true
  has_many :roles, dependent: :destroy, autosave: true
  has_many :hiring_team_roles, -> { hiring_teams }, class_name: "Role"
  has_many :role_permissions, through: :roles
  has_many :skills, dependent: :destroy, autosave: true
  has_many :specifications, dependent: :destroy, autosave: true
  has_many :interview_rounds, dependent: :destroy, autosave: true
  has_many :interview_types, dependent: :destroy, autosave: true
  has_many :statuses, dependent: :destroy, autosave: true
  has_many :rating_scales, dependent: :destroy, autosave: true
  has_many :rating_scale_options, through: :rating_scales, source: :options
  has_many :priorities, dependent: :destroy, autosave: true

  #Lets us get to just particular types of statuses directly
  has_many :candidate_statuses, -> { where(typeof: "candidate")}, class_name: "Status"
  has_many :interview_statuses, -> { where(typeof: "interview")}, class_name: "Status"
  has_many :job_statuses,       -> { where(typeof: "job")}, class_name: "Status"

  has_many :interview_guides, through: :jobs

  #TODO: This might be better represented as a named scoped, evaluate how its being used.
  #has_one :acceptance_rating_scale, -> { where(handle: :acceptance)}, class_name: 'AccountRatingScale', autosave: true
  #has_one :overall_rating_scale, -> {where(handle: :overall)}, class_name: 'AccountRatingScale', autosave: true


  # Children below are the bulk of the "transactional" data that grows with an Account
  has_many :jobs, dependent: :destroy, autosave: true
  has_many :candidates, dependent: :destroy, autosave: true
  has_many :users, through: :user_roles, autosave: true
  has_many :user_roles, :dependent => :destroy, autosave: true
  has_many :role_permissions, through: :roles

  has_many :invitations, dependent: :destroy, autosave: true
  has_many :invitations_account_managers, -> {where(role_id: Role.account_manager.id)}, class_name: 'Invitation', autosave: true

  has_many :candidate_priorities, class_name: 'AccountCandidatePriority', dependent: :destroy, autosave: true
  has_many :email_templates, dependent: :destroy

  accepts_nested_attributes_for :roles, allow_destroy: true
  accepts_nested_attributes_for :skills, allow_destroy: true
  accepts_nested_attributes_for :interview_rounds, allow_destroy: true
  accepts_nested_attributes_for :interview_types, allow_destroy: true
  accepts_nested_attributes_for :classifications, allow_destroy: true
  accepts_nested_attributes_for :specifications, allow_destroy: true
  accepts_nested_attributes_for :statuses, allow_destroy: true
  accepts_nested_attributes_for :rating_scales, allow_destroy: true
  accepts_nested_attributes_for :priorities, allow_destroy: true

  # following 3 statuses are just shortcuts to getting/setting specific types of statuses related to account
  accepts_nested_attributes_for :candidate_statuses, allow_destroy: true
  accepts_nested_attributes_for :interview_statuses, allow_destroy: true
  accepts_nested_attributes_for :job_statuses, allow_destroy: true

  #accepts_nested_attributes_for :overall_rating_scale
  #accepts_nested_attributes_for :acceptance_rating_scale


  accepts_nested_attributes_for :invitations_account_managers, allow_destroy: true

  # Commented out
  #has_attached_file :logo, styles: {thumb: "100x100>"},
  #                         default_url: "/assets/images/lg-Great-Hire-no-dot.es.png"


  validates :company_name, presence: true, uniqueness: { scope: :deleted_at}
  validates :email_domain, allow_blank: false, format: { with: /\A([A-Z0-9-]+\.)+[A-Z]{2,4}\z/i }

  # Scopes
  scope :active, -> {where(active: true)}
  scope :inactive, -> {where(active: false)}
  # Scope allows for "previewing" of objects by the author before release.
  scope :active_for_user, ->(user_id) {where("active = ? or created_by = ?", true, user_id)}

  # Constants
  ASSOCIATIONS_FOR_CLONE = [:statuses,
    :interview_rounds,:priorities,
    :specifications, :skills, {classifications: :options},
    {rating_scales: :options}, {roles: :role_permissions}, :interview_rounds, :interview_types, :email_templates]
    
  STATUSES = [['Active', 1], ['Inactive', 0]]

  # Callbacks
  after_update :add_submitted_status, if: :was_enable_job_request?


  # Creates a new Account object from another account
  def self.create_from (account, params={})
    # create_ is used as the method name to be consistent with AR's create vs initialize vs new, etc
    # If caller didn't pass ing a valid account, returning nil
    # is the signal of failure.
    return nil if account.nil?
    new_account = account.dup(except: [:is_template, :slug, :company_name, :email_domain, :owner_id], include: ASSOCIATIONS_FOR_CLONE)
    new_account.update_attributes(params)
    new_account.save!
    new_account
  end

  def should_generate_new_friendly_id?
    company_name_changed?
  end

  def add_submitted_status
    job_statuses.create({name: 'Submitted', default: true, active: true}) if job_statuses.where({name: 'Submitted'}).empty?
  end

  def was_enable_job_request?
    job_request_enabled_changed? && job_request_enabled
  end

  def rating_scales_by_handle
    @rating_scales ||= Hash[ *rating_scales.collect{|v| [v.handle, v] }.flatten]
  end

  def status
    self.active ? 'active' : 'inactive'
  end

  def job_manager_role
    @job_manager_role ||= roles.where(name: Rails.application.config.job_manager_role_name).first
  end

  def hiring_manager_role
    @hiring_manager_role ||= roles.where(name: Rails.application.config.hiring_manager_role_name).first
  end

  def candidate_role
    @candidate_role ||= roles.where(name: Rails.application.config.candidate_role_name).first
  end

  def interviewer_role
    @interviewer_role ||= roles.where(name: Rails.application.config.interviewer_role_name).first
  end

  def make_permission_role_mapping
    res = {}
    res.merge! RolePermission.global_permission_role_mapping
    for rp in role_permissions.to_a
      if rp.value
        (res[rp.permission_id] ||= []).push(rp.role)
      end
    end
    res
  end

  def permission_role_mapping
    @permission_role_mapping ||= make_permission_role_mapping
  end

  def invalidate_permission_role_mapping
    @permission_role_mapping = {}
  end

  def user_roles_for(user)
     user_roles.to_a.select{|x| x.user == user}.map{|x| x.role}
  end

  #def send_invitations emails, allow_these_users_to_invite, sender
  #  success = true
  #  errors = []
  #
  #  User.transaction do
  #    parse_emails(emails).each do |email|
  #      psw = Devise.friendly_token
  #      user = User.new(email: email, password: psw)
  #      user.skip_confirmation! if user.methods.include? :skip_confirmation!
  #      user.reset_password_token   = OpenSSL::HMAC.hexdigest('SHA256', 'reset_password_token', psw)
  #      user.reset_password_sent_at = Time.now.utc
  #
  #      activate_url = edit_password_url(user, {reset_password_token: user.reset_password_token}.merge(Rails.application.config.action_mailer.default_url_options))
  #      if user.save
  #        InvitationsMailer.send_invite(email, parsed_email_subject, parsed_email_body(sender) + "<a href='#{activate_url}'>Activate</a>").deliver
  #        # role = allow_these_users_to_invite ? Role.hiring_manager : Role.candidate
  #        AccountUser.create!(account_id: account.id, user_id: user.id) #, role_id: role.id)
  #      else
  #        success = false
  #        errors << {email => user.errors.messages[:email].first}
  #      end
  #    end
  #    raise ActiveRecord::Rollback unless success
  #  end
  #
  #  errors
  #end
  #
  #def parsed_email_subject
  #  invite_setting[:email_subject].gsub!('company_name', company_name)
  #end
  #
  #def parsed_email_body sender
  #  invite_setting[:email_body].gsub!('company_name', company_name).gsub!('current_user_full_name', "#{sender.first} #{sender.last}")
  #end

  def update_evaluate_permissions! evaluate_permissions
    evaluate_permissions.keys.each do |perm|
      evaluate_permissions[perm].each do |role_id, value|
        role = Role.find role_id
        role.set_permission_value(perm.to_sym, value.to_bool)
      end
    end
  end

  # Ensures slugs are only created when new records are made AND not specified by the user.
  # slug's should have a unique validation on them if the application lets the user specify the slug they want to use
  # as is common the case at the top-level context of "Account" in a multi-tenant system.
  def should_generate_new_friendly_id?
    new_record? & self.slug.nil?
  end

  private

end

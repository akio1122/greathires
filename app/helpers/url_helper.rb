module UrlHelper
  
  def vanity_subdomain?
    request.subdomain.present? && !Rails.application.config.non_vanity_subdomains.include?(request.subdomain)
  end

  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, request.domain, request.port_string].join
  end
  
  def url_for(options = nil)
    #puts "--- url_for, options = #{options}"
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))
    end
    super
  end
  
  # contextualized_path determines if the main context object, Account, should be part of the generated path
  # If so, its included in url_for call.  However, if the account slug is the subdomain, then do not include it.
  
  def contextualized_path(objs, account = current_account)
    puts "-- contextualized_path, vanity_subdomain?=#{vanity_subdomain?}"
    if vanity_subdomain?
       url_for(objs)
    else
      return url_for([account, *objs])
    end
  
    #return url_for(objs)
    #unless vanity_subdomain?
    ##  objs.unshift(context_obj)
    #end
  end

#TODO: Vladimir: You should review the need for this given most of what you need to do can be handled by contextualized_path
  def contextualized_account_update_path(context_obj, *objs)
    unless vanity_subdomain?
      update_attributes_account_manage_account_index_path(objs)
    else
      update_attributes_manage_account_index_path
    end
  end

  def contextualized_account_setup_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      setup_account_manage_account_index_path objs
    else
      setup_manage_account_index_path
    end
  end

  def contextualized_account_job_specifications_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      job_specifications_account_manage_account_index_path(objs)
    else
      job_specifications_manage_account_index_path
    end
  end

  def contextualized_hiring_team_roles_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      hiring_team_roles_account_manage_account_index_path(objs)
    else
      hiring_team_roles_manage_account_index_path
    end
  end

  def contextualized_account_interview_rounds_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      interview_rounds_account_manage_account_index_path(objs)
    else
      interview_rounds_manage_account_index_path
    end
  end

  def contextualized_account_permissions_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      permissions_account_manage_account_index_path(objs)
    else
      permissions_manage_account_index_path
    end
  end

  def contextualized_account_interview_guides_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      interview_guides_account_manage_account_index_path(objs)
    else
      interview_guides_manage_account_index_path
    end
  end

  def contextualized_account_prepare_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      prepare_account_manage_account_index_path(objs)
    else
      prepare_manage_account_index_path(objs)
    end
  end

  def contextualized_account_interview_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      interview_account_manage_account_index_path(objs)
    else
      interview_manage_account_index_path
    end
  end
  
  def contextualized_account_evaluate_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      evaluate_account_manage_account_index_path(objs)
    else
      evaluate_manage_account_index_path
    end
  end
  
  def contextualized_account_candidate_statuses_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      candidate_statuses_account_manage_account_index_path(objs)
    else
      candidate_statuses_manage_account_index_path
    end
  end

  def contextualized_account_invite_users_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      invite_users_account_manage_account_index_path(objs)
    else
      invite_users_manage_account_index_path(objs)
    end
  end

  def contextualized_jobs_index_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      account_job_index_path(objs)
    else
      job_index_path(objs)
    end
  end

  def contextualized_interviews_path(context_obj, *objs)
    unless vanity_subdomain?
      objs.unshift(context_obj)
      account_interviews_path(objs)
    else
      interviews_path(objs)
    end
  end

  def contextualized_jobs_new_path(context_obj, *objs)
    unless vanity_subdomain?
      new_account_job_path(context_obj, *objs)
    else
      new_job_path(*objs)
    end
  end

  def contextualized_jobs_edit_path(context_obj, *objs)
    unless vanity_subdomain?
      edit_account_job_path(context_obj, *objs)
    else
      edit_job_path(*objs)
    end
  end

  def contextualized_candidate_summary_path(context_obj, *objs)
    unless vanity_subdomain?
      candidate_summary_account_job_path(context_obj, *objs)
    else
      candidate_summary_job_path(*objs)
    end
  end

  def contextualized_results_summary_path(context_obj, *objs)
    unless vanity_subdomain?
      results_summary_account_job_path(context_obj, *objs)
    else
      results_summary_job_path(*objs)
    end
  end

  def contextualized_jobs_hiring_team_path(context_obj, *objs)
    unless vanity_subdomain?
      hiring_team_account_job_path(context_obj, *objs)
    else
      hiring_team_job_path(*objs)
    end
  end

  def contextualized_jobs_interview_guides_path(context_obj, *objs)
    unless vanity_subdomain?
      interview_guides_account_job_path(context_obj, *objs)
    else
      interview_guides_job_path(*objs)
    end
  end

  def contextualized_jobs_specification_section_path(context_obj, *objs)
    unless vanity_subdomain?
      job_specification_section_account_job_path(context_obj, *objs)
    else
      job_specification_section_job_path(*objs)
    end
  end

  def contextualized_jobs_skill_path(context_obj, *objs)
    unless vanity_subdomain?
      job_skill_account_job_path(context_obj, *objs)
    else
      job_skill_job_path(*objs)
    end
  end

  def contextualized_candidate_path(context_obj, *objs)
    unless vanity_subdomain?
      account_candidate_profile_path(context_obj, *objs)
    else
      candidate_profile_path(*objs)
    end
  end
end


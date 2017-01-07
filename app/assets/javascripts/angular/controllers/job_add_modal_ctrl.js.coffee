app.controller "JobAddModalCtrl", ($scope, $window, $modalInstance, $timeout, Job, JobRole, current_user, account) ->

  # --- Internal Use Variables ---

  # --- Scoped Variables ----
  $scope.new_job_type = "create" # new job type : create, template, past
  $scope.job_title = "" # new job title
  $scope.job_req = "" # new job req

  $scope.suggestions = []
  $scope.search_text = "" # job templates auto complete text
  $scope.is_selected = true # template or past job is selected
  $scope.validation_errors = []
  $scope.suggestion_id = 0

  Job.getExistingJobTemplate(account.id) \
  .then (resources) -> 
    $scope.job_templates = resources
  .catch (errorResponse) -> console.log "JobAddModalCtrl.getExistingJobTemplate, error=" + errorResponse

  Job.getPastJobs(account.id) \
  .then (resources) -> 
    $scope.past_jobs = resources    
  .catch (errorResponse) -> console.log "JobAddModalCtrl.getPastJobs, error=" + errorResponse

  # --- Methods --- 
  resetForm = () ->
    $scope.search_text = ""
    $scope.job_title = ""
    $scope.job_req = ""
    $scope.is_selected = false
    $scope.suggestion_id = 0
    $scope.form.jobForm["name"].$setPristine()
    $scope.form.jobForm["name"].$setValidity("serverError", true)
    $scope.form.jobForm["requisition_ref"].$setPristine()
    $scope.form.jobForm["requisition_ref"].$setValidity("serverError", true)

  # --- Scoped Methods ---
  $scope.setFormScope =(form)->
    $scope.form = form

  $scope.chooseCreateJobType = () ->
    resetForm()
    $scope.is_selected = true if $scope.new_job_type is "create"

  # job templates auto complete
  $scope.searchTemplateSuggestions = () ->
    $scope.suggestions = $scope.job_templates.findAll((item)-> item.name.indexOf($scope.search_text) isnt -1)

  $scope.hideSuggestions = () ->
    $timeout ->
      $scope.suggestions = []
    , 200

  $scope.selectSuggestion = (suggestion) ->
    $scope.suggestion_id = suggestion.id
    $scope.search_text = suggestion.name
    $scope.job_title = "Copy of " + suggestion.name
    # $scope.job_req = suggestion.requisition_ref  
    $scope.job_req = ""
    $scope.hideSuggestions()
    $scope.is_selected = true

  # past jobs auto complete
  $scope.searchPastJobSuggestions = () ->
    $scope.suggestions = $scope.past_jobs.findAll((item)-> item.name.indexOf($scope.search_text) isnt -1)

  # add new job
  $scope.addJob = () ->
    $scope.validation_errors["name"] = []
    $scope.validation_errors["requisition_ref"] = []

    attrs =
      name : $scope.job_title
      requisition_ref : $scope.job_req

    Job.create(account.id, attrs, $scope.suggestion_id) \
    .then (resource) ->       
      current_job = resource
      # find Job Manager Role ID
      JM_role = account.hiring_team_roles.find((item) -> item.name is "Job Manager")
      # current user assign to job manager role
      params =
        job_id: current_job.id
        account_id: account.id
        role_id: JM_role.id
        user_id: current_user.id
        user: current_user
      JobRole.create(current_job.id, params)
      .then (resource)->
        $window.location.href = "/accounts/" + account.slug + "/jobs/" + current_job.id + "/edit"
        # console.log resource
      .catch (errorResponse)->
        console.log errorResponse
    .catch (errorResponse) -> 
      if errorResponse.status is 401 or errorResponse.status is 422       
        angular.forEach errorResponse.data.errors, (error)->
          if error.indexOf("Name") is 0
            $scope.form.jobForm["name"].$setValidity("serverError", false)
            $scope.validation_errors["name"].push(error)

          if error.indexOf("Requisition") is 0
            $scope.form.jobForm["requisition_ref"].$setValidity("serverError", false)
            $scope.validation_errors["requisition_ref"].push(error)

  $scope.closeModal = ()->
    $modalInstance.dismiss 'cancel'
app.controller "JobSetupCtrl", ["$scope", "$stateParams", "$location", "Job", "Classification", "JobClassification", \
                            ($scope, $stateParams, $location, Job, Classification, JobClassification) ->
  # Job sub controllers depend on $scope. resources already loaded from the job_controller which acts
  # list a root controller leveraging UI-Router $scope inheritance using nested views.

  $scope.job_specification = "Job Specification"
  $scope.job_specification = $scope.account.job_spec_categories_label if $scope.account.job_spec_categories_label

  # Update takes a resource and optional event object.
  $scope.update = (resource, e) ->
    # console.log "-- JobSetupCtrl.update, resource=" + JSON.stringify(resource) + ", e=" + e
    # if statement handles the case of a drop-down changing that doesn't neccessarily come with an event.
    if !e? || $scope.form[e.target.name].$dirty
      Job.update(resource) \
      .then ((response) -> $scope.handleSuccess(response, e))
      .catch((response) -> $scope.handleFailure(response, e))


  # ######## Classification-related methods.
  $scope.updateClassification = (resource, classification_id, option_id) ->
    #TODO: Finish implementation
    result = JobClassification.save(resource.id, classification_id, option_id)
    for job_classification in $scope.resource.job_classifications
      job_classification.classification_option_id = option_id if classification_id is job_classification.classification_id

  $scope.getClassifications = () ->
    if $scope.classifications?
      $scope.classifications
    else
      console.log "-- $scope.determineAccountId()= " + $scope.determineAccountId()
      Classification.all($scope.determineAccountId()) \
      .then (resources) ->
        $scope.classifications = resources
        for classification in $scope.classifications
          for job_classification in $scope.resource.job_classifications
            classification.selectedId = job_classification.classification_option_id if classification.id is job_classification.classification_id
      .catch (errorResponse) ->
        console.log  "errorResponse = " + errorResponse
        $scope.classifications = []


  # ####### HELPER METHODS
  $scope.inputIsValid = (form, input_name, isValid, errors) ->
    if isValid
      form[input_name].$setPristine()
      form[input_name].$setValidity("serverError", true)
    else
      form[input_name].$setValidity("serverError", false)
    $scope.validation_errors[input_name] = errors

  $scope.handleSuccess = (response, e) ->
    # if event was passed in, update form flags and validation messaging.
    if e? then $scope.inputIsValid($scope.form, e.target.name, true, null)

  $scope.handleFailure = (response, e) ->
    # handleFailure is used to manage XHR posting failures of all kinds.

    # Handle Rails model validation error returned with status of 422 - unprocessable entity
    if response.status = 422
      # If event was passed in, update form flags and validation messaging.
      if e? then $scope.inputIsValid($scope.form, e.target.name, false, response.data.errors)
  #TODO: If event trigger not available, display a Flash message indicating the failure.


]
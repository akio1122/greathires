# DESCRIPTION: JobsCtrl handles views that act upon many jobs at a time.
app.controller "JobsCtrl", ["$scope", "$location", "$modal", "$stateParams", "Job", \
                            ($scope, $location, $modal, $stateParams, Job) ->

  # Contains hash of server validation errors with key being name of form field.
  $scope.validation_errors = {}

  # Init takes a jsonified resource from Rails models and establishes them
  # for use in the AngularController.
  #$scope.init = (preload_resources) ->
    #console.log "-- JobsCtrl, $scope.preloaded=" + JSON.stringify(preload_resources)

  # preload_resources is from ng-init of content ui-view
  $scope.current_account = $scope.preload_resources?.account || null
  $scope.current_user = $scope.preload_resources?.current_user || null
  $scope.resources = $scope.preload_resources?.resources || null
  $scope.job_statuses = $scope.preload_resources?.job_statuses || null

  $scope.openAddJobModal = () ->
    $modal.open(
      templateUrl:  "job_lister/add_job.html"
      controller: 'JobAddModalCtrl'
      # size: 'sm'
      resolve:
        current_user: -> $scope.current_user
        account: -> $scope.current_account
    )

  # Update takes a resource and optional event object.
  $scope.update = (resource, e) ->
    #if statement handles the case of a drop-down changing that doesn't neccessarily come with an event.
    if !e? || $scope.form[e.target.name].$dirty
      Job.update(resource) \
      .catch (errorResponse) -> console.log "-- JobIndexCtrl.update, errorResponse=" + errorResponse

  $scope.editPath = (item) ->
    "#{$scope.urls['resource_root']}/#{item.id}/edit"

  $scope.hiringManagers = (user_roles) ->
    # Returns a hiring manager's name if there is one defined.
    #user_roles.each((item) -> console.log item.name)
    hm = user_roles.filter((item) -> item.name=="Hiring Manager")
    return hm[0]?.user_full_name || ""

  $scope.justDate = (date_string) ->
    Date.create(date_string).format('{Month} {d}, {yyyy}')

  $scope.getJobDetailTooltip = (user_roles) ->
    if($scope.checkPermission("update_job", user_roles))
      "Edit Job Details"
    else
      "View Job Details"

  # Job Permission Checking
  $scope.checkPermission = (action, user_roles) ->
    Job.checkPermission(action, user_roles, $scope.current_account.role_permissions)

]

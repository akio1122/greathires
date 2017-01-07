app.controller "JobCtrl", ["$scope", "$state", "$stateParams", "$location", "$modal", "Account", "Job", \
                            ($scope, $state, $stateParams, $location, $modal, Account, Job) ->

  # Contains hash of server validation errors with key being name of form field.
  $scope.validation_errors = {}

  # Init initializes the JobEditor.
  # It can take JSONified resources from Rails. If available, these are placed upon the scope.
  # If not, load proceeds to load the resource based upon the RESTful URL /jobs/:job_id
  #$scope.init = (preload_resources) ->
  #  $scope.account = preload_resources?.account || $scope.loadAccount()
  #  $scope.current_user = preload_resources?.current_user || null
  #  $scope.resource = preload_resources?.resource || null
  #  $scope.job_roles = preload_resources?.job_roles || null
  #  $scope.loadResource()

  $scope.account = $scope.preload_resources?.account || $scope.loadAccount()
  $scope.current_user = $scope.preload_resources?.current_user || null
  $scope.resource = $scope.preload_resources?.resource || null
  $scope.job_roles = $scope.preload_resources?.job_roles || null  

  $scope.determineAccountId = () ->
    if $scope.account?.id?
      return $scope.account.id
    else
      url_segments = $location.absUrl().split('/')

      # Next examine URL path
      found_index = url_segments.findIndex("accounts")
      if found_index > 0
        return url_segments[found_index+1]

      # Lastly examine subdomain, if not "www" assume its a vanity subdomain equivalent to the account slug
      url_domain_segments = url_segments[0].split(":")[0]
      if url_domain_segments[0] != "www"
        url_domain_segments[0]
      else
        -1

  $scope.loadAccount = () ->
    if !$scope.account?
      Account.get($scope.determineAccountId()) \
      .then (resource) ->
        console.log "-- Loading from fetched account"
        $scope.account = resource
      .catch (errorResponse) -> console.log "JobCtrl.loadAccount, errorResponse=" + errorResponse

  # Load loads the resource from XHR if not supplied.
  $scope.loadResource = () ->
    # Load resource into scope from preloaded data or from specified id
    if $scope.preloaded?.resource?
      console.log "-- already have resource preloaded, not loading."
      $scope.resource = $scope.preloaded.resource
    else
      console.log "--Request for load by id loading via XHR."
      Job.get($scope.findJobIdFromUrl($location.absUrl(), 'jobs')) \
      .then (resource) ->
        $scope.resource = resource
      .catch (errorResponse) -> console.log "JobCtrl.id, errorResponse=" + errorResponse

  # findJobIdFromUrl examines the full URL and returns the segment past the
  # segment_name caller is attempting to find.
  $scope.findJobIdFromUrl = (url, segment_name) ->
    url_segments = url.split('/')
    found_index = url_segments.findIndex segment_name
    url_segments[found_index+1]

  $scope.openSaveJobTemplateModal = () ->
    $modal.open(
      templateUrl: "job_editor/add_job_template.html"
      controller: 'JobAddTemplateModalCtrl'
      size: 'sm'
      resolve:
        resource: -> $scope.resource
      #  account: -> $scope.current_account
    )

  # Job Permission Checking
  $scope.checkPermission = (action) ->
    Job.checkPermission(action, $scope.resource.user_roles, $scope.account.role_permissions)

  $scope.can_edit = $scope.checkPermission("update_job")
]
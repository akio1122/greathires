

app.controller "JECtrl", ["$scope", "$stateParams", "Restangular", ($scope, $stateParams, Restangular) ->
  # Contains hash of server validation errors with key being name of form field.
  $scope.validation_errors = {}

  # Preload takes a jsonified resource from Rails models and establishes them
  # for use in the AngularController.
  $scope.preload = (preload_resources) ->
    console.log "-- JECtrl, $scope.preloaded=" + JSON.stringify(preload_resources)
    $scope.preloaded = preload_resources

    # Load jobs if passed in.
    if preload_resources?.job? then $scope.resource = preload_resources.job

  $scope.load = (id) ->
      # Load resource into scope from preloaded data or from specified id
    if !id && $scope.preloaded?.resource?
      console.log "-- already have resource preloaded, not loading."
      $scope.resource = $scope.preloaded.resource
    else
      console.log "--Request for load by id loading via XHR."
      Restangular.one("jobs", id).get().then (resource) ->
        $scope.resource = resource

]
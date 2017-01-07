app.controller "AccountCandidateStatusCtrl", ["$scope", "$state", "$stateParams", "Status", \
                                        ($scope, $state, $stateParams, Status) ->

  $scope.loadStatuses = ()->
    Status.all($scope.account.id, active: 'all')
    .then (responses) ->
      $scope.account.statuses = responses.groupBy (item)-> item.typeof
      $scope.account.statuses.candidate = [] unless $scope.account.statuses.candidate?
      $scope.account.statuses.interview = [] unless $scope.account.statuses.interview?
      $scope.account.statuses.job = [] unless $scope.account.statuses.job?
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.validateStatus = (name, type)->
    return 'Name is required' if name.isBlank()
    # validate by uniq name
    status = $scope.account.statuses[type].find (item)-> name == item.name
    return 'Name is already taken' if status?

  $scope.createStatus = (name, type)->
    # reset form
    $scope.new_status = ""
    attrs = 
      active: true
      name: name
      account_id: $scope.account.id
      typeof: type

    Status.create $scope.account.id, attrs
    .then (response) ->
      $scope.account.statuses[type].push response
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.setAsDefault = (item)->
    $scope.account.statuses[item.typeof].each (status)->
      status.default = false if status.default

    item.default = true
    item.active = true
    $scope.updateStatus(item)

  $scope.updateStatus = (item)->
    attrs = 
      active: item.active
      name: item.name
      default: item.default
    Status.update item.id, $scope.account.id, attrs
    .then (response) ->
      console.log 'Ok'
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.deleteStatus = (item)->
    return if item.default || item.is_locked
    type = item.typeof
    Status.remove item.id
    .then (response) ->
      index = $scope.account.statuses[type].indexOf(item)
      $scope.account.statuses[type].splice index, 1

    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  # initialize
  $scope.loadStatuses() unless $scope.account.statuses?
]
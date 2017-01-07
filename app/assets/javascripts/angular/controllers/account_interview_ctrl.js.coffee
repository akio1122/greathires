app.controller "AccountInterviewCtrl", ["$scope", "$state", "$stateParams", "Proirity", \
                                        ($scope, $state, $stateParams, Proirity) ->

  $scope.loadProirities = ()->
    Proirity.all($scope.account.id, active: 'all')
    .then (responses) ->
      $scope.account.proirities = responses.groupBy (item)-> item.priority_group
      $scope.proirity_groups = Object.keys($scope.account.proirities)

      $scope.account.proirities.roles = [] unless $scope.account.proirities.roles?
      $scope.account.proirities.compensations_and_benefits = [] unless $scope.account.proirities.compensations_and_benefits?
      $scope.account.proirities.companies = [] unless $scope.account.proirities.companies?
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.validateProirity = (name, priority_group)->
    return 'Name is required' if name.isBlank()
    # validate by uniq name
    status = $scope.account.proirities[priority_group].find (item)-> name == item.name
    return 'Name is already taken' if status?

  $scope.createProirity = (name, priority_group)->
    # reset form
    $scope.new_proirity = ""
    attrs = 
      active: true
      name: name
      account_id: $scope.account.id
      priority_group: priority_group

    Proirity.create $scope.account.id, attrs
    .then (response) ->
      $scope.account.proirities[priority_group].push response
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.updateProirity = (item)->
    attrs = 
      active: item.active
      name: item.name

    Proirity.update item.id, $scope.account.id, attrs
    .then (response) ->
      console.log 'Ok'
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.deleteProirity = (item)->
    priority_group = item.priority_group
    Proirity.remove item.id
    .then (response) ->
      index = $scope.account.proirities[priority_group].indexOf(item)
      $scope.account.proirities[priority_group].splice index, 1

    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  # initialize
  $scope.loadProirities() unless $scope.account.proirities?
]
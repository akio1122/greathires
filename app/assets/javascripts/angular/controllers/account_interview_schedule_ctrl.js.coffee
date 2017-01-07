app.controller "AccountInterviewScheduleCtrl", ["$scope", "$state", "$stateParams", "InterviewRound", "InterviewType", \
                                        ($scope, $state, $stateParams, InterviewRound, InterviewType) ->

  # interview rounds
  $scope.loadInterviewRounds = ->
    InterviewRound.all($scope.account.id, active: 'all')
    .then (responses) ->
      $scope.account.interview_rounds = responses
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.validateInterviewRound = (name)->
    return 'Name is required' if name.isBlank()
    # validate by uniq name
    interview_round = $scope.account.interview_rounds.find (item)-> name == item.name
    return 'Name is already taken' if interview_round?

  $scope.createInterviewRound = (name)->
    $scope.new_round = ""
    attrs = 
      active: true
      name: name
      account_id: $scope.account.id
    InterviewRound.create $scope.account.id, attrs
    .then (response) ->
      $scope.account.interview_rounds.push response
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.updateInterviewRound = (item)->
    attrs = 
      active: item.active
      name: item.name
    InterviewRound.update item.id, $scope.account.id, attrs
    .then (response) ->
      console.log 'Ok'
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.deleteInterviewRound = (item)->
    InterviewRound.remove item.id
    .then (response) ->
      index = $scope.account.interview_rounds.indexOf(item)
      $scope.account.interview_rounds.splice index, 1

    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  # interview types
  $scope.loadInterviewTypes = ->
    InterviewType.all($scope.account.id, active: 'all')
    .then (responses) ->
      $scope.account.interview_types = responses
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

    $scope.validateInterviewType = (name)->
    return 'Name is required' if name.isBlank()
    # validate by uniq name
    interview_type = $scope.account.interview_types.find (item)-> name == item.name
    return 'Name is already taken' if interview_type?

  $scope.createInterviewType = (name)->
    $scope.new_type = ""
    attrs = 
      active: true
      name: name
      account_id: $scope.account.id
    InterviewType.create $scope.account.id, attrs
    .then (response) ->
      $scope.account.interview_types.push response
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.updateInterviewType = (item)->
    attrs = 
      active: item.active
      name: item.name
    InterviewType.update item.id, $scope.account.id, attrs
    .then (response) ->
      console.log 'Ok'
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.deleteInterviewType = (item)->
    InterviewType.remove item.id
    .then (response) ->
      index = $scope.account.interview_types.indexOf(item)
      $scope.account.interview_types.splice index, 1

    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  # initialize
  $scope.loadInterviewRounds() unless $scope.account.interview_rounds?
  $scope.loadInterviewTypes() unless $scope.account.interview_types?
]
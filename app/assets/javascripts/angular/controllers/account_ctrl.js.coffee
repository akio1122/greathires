app.controller "AccountCtrl", ["$scope", "$state", "$stateParams", "$location", "Account", \
                            ($scope, $state, $stateParams, $location, Account) ->

  # Contains hash of server validation errors with key being name of form field.
  $scope.validation_errors = {}
  # 
  $scope.active_field = null
  $scope.waiting = false

	# Init initializes the AccountEditor.
  # It can take JSONified resources from Rails. If available, these are placed upon the scope.
  # If not, load proceeds to load the resource based upon the RESTful URL /jobs/:job_id
  # $scope.init = (preload_resources) ->
  #   $scope.account = preload_resources?.account || null
  #   $scope.current_user = preload_resources?.current_user || null
  #   $scope.user_roles = preload_resources?.user_roles || null

  $scope.account = $scope.preload_resources?.account || null
  $scope.current_user = $scope.preload_resources?.current_user || null
  $scope.user_roles = $scope.preload_resources?.user_roles || null

  $scope.activeField = (name=null) ->
    return if $scope.waiting
    $scope.restoreAccount()
    $scope.active_field = name

  $scope.updateAccount = (name) ->
    return if $scope.waiting
    $scope.waiting = true
    Account.update($scope.account)
    .then (res)->
      $scope.backUpAccount()
      $scope.waiting = false
      $scope.validation_errors = {}
      $scope.active_field = null
    .catch (errorResponse) ->
      $scope.waiting = false
      if errorResponse.status is 401 or errorResponse.status is 422
        $scope.validation_errors[name] = errorResponse.data.errors.join(',')

      console.debug errorResponse.status, errorResponse.data

  $scope.backUpAccount = ->
    $scope.back_up_account = angular.copy($scope.account)

  $scope.restoreAccount = ->
    $scope.account = angular.copy($scope.back_up_account)

  $scope.updateAccountPreferences = ->
    Account.update($scope.account)

  $scope.backUpAccount()
]
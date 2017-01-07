app.controller "AccountManageUsersCtrl", ["$scope", "$state", "$stateParams", "UserRole", \
                                        ($scope, $stateParams, $state, UserRole) ->


  $scope.user_statuses = [{code: 1, name: 'Active'}, {code: 0, name: 'Inactive'}, {code: -1, name: 'Unacknowledged'}]
  $scope.resources = []
  $scope.loadAccountUsers = ->
    params =
      page: $scope.current_page

    params.role_id = $scope.current_role.id if $scope.current_role?.id?
    params.status = $scope.current_status.code if $scope.current_status?.code?

    UserRole.all($scope.account.id, params)
    .then (response) ->
      $scope.resources = response.collection
      # paginator config
      $scope.current_page = response.pagination.current_page
      $scope.items_per_page = response.pagination.per_page
      $scope.total_pages = response.pagination.total_pages
      $scope.total_items = $scope.items_per_page * $scope.total_pages
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.updateResource = (item)->
    UserRole.update(item.id, item.role_id, item.status)
    .then (res)->
      console.log "Ok"
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.editResource = (item)->
    # TODO: inmplement

  $scope.removeResource = (item)->
    UserRole.remove($scope.account.id, item.id)
    .then (res)->
      $scope.loadAccountUsers()
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  # filters config
  $scope.is_open_role_filter = false
  $scope.current_role = {name: 'All Roles'}
  $scope.role_filter_items = []
  $scope.role_filter_items.add $scope.current_role
  $scope.role_filter_items.add $scope.account.roles

  $scope.is_open_status_filter = false
  $scope.current_status = {name: 'All Statuses'}
  $scope.status_filter_items = []
  $scope.status_filter_items.add $scope.current_status
  $scope.status_filter_items.add $scope.user_statuses

  $scope.filterByRole = (item, $event)->
    $event.preventDefault()
    $scope.current_role = item
    $scope.is_open_role_filter = false
    $scope.loadAccountUsers()

  $scope.filterByStatus = (item, $event)->
    $event.preventDefault()
    $scope.current_status = item
    $scope.is_open_status_filter = false
    $scope.loadAccountUsers()

  # paginator config
  $scope.current_page = 1
  $scope.max_size = 5

  $scope.pageChanged = ->
    $scope.loadAccountUsers()


  $scope.loadAccountUsers()
]
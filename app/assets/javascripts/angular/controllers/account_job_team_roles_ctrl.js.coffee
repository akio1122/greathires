app.controller "AccountJobTeamRolesCtrl", ["$scope", "$state", "$stateParams", "$modal", "Role", "RolePermission", "Permission", \
                                        ($scope, $state, $stateParams, $modal, Role, RolePermission, Permission) ->

  $scope.alerts = []
  $scope.role = {}
  $scope.waiting = false

  $scope.loadPermissions = ->
    Permission.all($scope.account.id)
    .then (response) ->
      $scope.grouped_permissions = response.groupBy (item)-> item.group
      $scope.permission_groups = Object.keys($scope.grouped_permissions)
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.loadRolePermissions = ->
    RolePermission.all($scope.account.id)
    .then (response) ->
      $scope.account.role_permissions = response
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.loadRoles = ->
    RolePermission.all($scope.account.id)
    .then (response) ->
      $scope.account.roles = response
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.getRolePermission = (perm, role)->
    $scope.account.role_permissions.find (item)-> item.role_id == role.id && item.permission_id == perm.id

  $scope.validateRole = (role_name)->
    return 'Name is required' if role_name.isBlank()
    # validate by uniq name
    role = $scope.account.roles.find (role)-> role_name == role.name
    return 'Name is already taken' if role?

  $scope.createRole = (item, close=false)->
    $scope.alerts = []
    Role.create($scope.account.id, item.name, item.template_id)
    .then (res)->
      $scope.account.roles.push res
      $scope.loadRolePermissions()
      if close then $scope.closeModal() else $scope.resetForm()

    .catch (errorResponse) ->
      if errorResponse.status is 422
        $scope.alerts.push({type: 'danger', msg: errorResponse.data.errors.join(',')})
      console.log "errorResponse = " + errorResponse

  $scope.updateRole = (item)->
    Role.update(item.id, item.name)
    .then (res)->
      console.log "Ok"
    # .catch (errorResponse) ->
    #   console.log "errorResponse = " + errorResponse

  $scope.updateRolePermission = (item)->
    RolePermission.update(item.id, item.value)
    .then (res)->
      console.log "Ok"
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.addRole =->
    $scope.modalInstance = $modal.open
      templateUrl:  "account_editor/new_hiring_role.html"
      controller: 'AccountJobTeamRolesCtrl'
      size: 'md'
      scope: $scope
      backdrop: 'static'

    $scope.modalInstance.result
    .then (persons) ->
      a = 1

    .catch () ->
      # User abandoned changes.
      console.log "-- Returned from closed modal, in . catch"

  $scope.editRole = (item)->
    # TODO: implement

  $scope.removeRole = (item)->
    Role.remove($scope.account.id, item.id)
    .then (res)->
      index = $scope.account.roles.indexOf(item)
      $scope.account.roles.splice index, 1
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  # modal helper methods
  $scope.closeModal = ()->
    $scope.modalInstance.close()

  $scope.resetForm = ()->
    $scope.role = {}

  $scope.saveAndAddAnother = (role)->
    $scope.createRole(role)

  $scope.save = (role)->
    $scope.createRole(role, true)

  # init
  $scope.loadPermissions() unless $scope.grouped_permissions?

  if $scope.account.role_permissions?
    $scope.loadRolePermissions()
  else
    $scope.role_permissions = $scope.account.role_permissions.groupBy (item)-> item.permission_group

  $scope.loadRoles() unless $scope.account.roles?

]
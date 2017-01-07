app.controller "HiringTeamCtrl", ($scope, $stateParams, $state, $modal, Job, JobRole) ->
  $scope.job = $scope.resource
  $scope.current_role = null

  $scope.associateJobRolesWithRole = ()->
    $scope.job_roles.each (job_role)-> $scope.associateJobRoleWithRole(job_role)

  $scope.associateJobRoleWithRole = (job_role)->
    role = $scope.account.hiring_team_roles.find (role)-> job_role.role_id == role.id
    if role?
      role.job_roles ||= []
      isExists = role.job_roles.find( (jr)-> jr.id == job_role.id )
      role.job_roles.push(job_role) unless isExists?

  $scope.getJobRoles = () ->
    JobRole.all($scope.job.id, hiring_team: true)
    .then (resources) ->
      $scope.account.hiring_team_roles = resources.groupBy (item)-> item.name
      resources
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse
      []

  $scope.removeJobRole = (job_role)->
    JobRole.remove(job_role.id)
    .then (resource) ->
      $scope.account.hiring_team_roles.each (role)->
        if role.job_roles
          role.job_roles.remove (item)-> item.id == job_role.id

    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse
      []

  $scope.saveJobRole = (user)->
    console.log "-- saveJobRole, user=" + JSON.stringify(user)
    params =
      job_id: $scope.resource.id
      account_id: $scope.account.id
      role_id: $scope.current_role.id

    params['user_id'] = user.id if user.id?
    params['user'] = user

    JobRole.create($scope.resource.id, params)
    .then (resource)->
      $scope.associateJobRoleWithRole(resource)
    .catch (errorResponse)->
      console.log errorResponse

  $scope.openAddUserModal = (role)->
    $scope.current_role = role
    params =
      entityLabel: -> role.name
      currentAccountId: -> $scope.account.id
      isAuthenticatedToLinkedIn: -> $scope.current_user.is_authenticated_to_linkedIn
      enableLinkedIn: -> true
      existingUserSelectable: -> true
      selectedPersonForUpdate: -> {}
      existingPersons: -> $scope.current_role.job_roles
      saveOnce: -> false

    modalInstance = $modal.open
      templateUrl:  "components/user_selector.html"
      controller: 'UserSelectorCtrl'
      size: 'lg' if $scope.current_user.is_authenticated_to_linkedIn
      resolve: params
      backdrop: 'static'

    modalInstance.result
    .then (persons) ->
      persons.each((person) -> $scope.saveJobRole(person))

    .catch () ->
      # User abandoned changes.
      console.log "-- Returned from closed modal, in . catch"



# TODO refactor
  $scope.cannotBeAddedRemoved = (role)->
    role.name.toLocaleLowerCase() != "interviewer"

  $scope.job_roles = $scope.job?.user_roles || $scope.getJobRoles()
  $scope.associateJobRolesWithRole()

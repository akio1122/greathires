# DESCRIPTION: InvitationsCtrl handles views that act upon many invitations at a time.
app.controller "AccountInviteUserCtrl", ["$scope", "$modal", "$stateParams", "User", "Invitation", \
                            ($scope, $modal, $stateParams, User, Invitation) ->
  $scope.alerts = []
  $scope.invitations = []

  currentIndex = null

  $scope.openInvitationModal = (index=-1) ->
    currentIndex = index
    if index == -1
      personToUpdate = {}
    else
      personToUpdate = angular.copy $scope.invitations[index] #if updating pass in person to update.

    params =
      entityLabel: -> "User"
      currentAccountId: -> $scope.account.id
      isAuthenticatedToLinkedIn: -> $scope.current_user.is_authenticated_to_linkedIn
      enableLinkedIn: -> true
      existingUserSelectable: -> false
      selectedPersonForUpdate: -> personToUpdate
      existingPersons: -> $scope.invitations
      saveOnce: -> false

    modalInstance = $modal.open
      templateUrl:  "components/user_selector.html"
      controller:  'UserSelectorCtrl'
      size: 'lg' if $scope.current_user.is_authenticated_to_linkedIn     # use small size if modal contains only warning message
      resolve: params
      backdrop: 'static'

    modalInstance.result
    .then (persons) ->
      persons.each((person) ->
        if person.isUpdating? 
          $scope.editPerson(person)
        else
          $scope.addPerson(person)
      )
      
      console.log JSON.stringify(persons)
    .catch () ->
      console.log "-- Returned from closed modal, in . catch"



  $scope.addPerson = (person)->
    person["role_id"] = $scope.user_roles.find( (e)-> e.name == "Account User" )?.id
    $scope.invitations.push(person)

  $scope.editPerson = (person)->
    if !person.role_id?
      user["role_id"] = $scope.user_roles.find( (e)-> e.name == "Account User" )?.id
    
    $scope.invitations[currentIndex] = person

  $scope.deleteItem = (index, id) ->
    $scope.invitations.splice index, 1

  $scope.inviteUsers = ->
    Invitation.invite($scope.account.id, JSON.stringify($scope.invitations))
    .then (result) ->
      console.log "Success"
      $scope.alerts = []
      $scope.alerts.push({type: 'success', msg: "Your invitation(s) has been sent!"})
      $scope.invitations = []
  
  $scope.closeAlert = ->
    $scope.alerts = []
    
]

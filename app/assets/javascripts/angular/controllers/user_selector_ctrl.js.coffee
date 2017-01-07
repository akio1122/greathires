app.directive "checkEmailOnBlur", ->
  EMAIL_REGX = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  restrict: "A"
  require: "ngModel"
  link: (scope, elm, attr, ctrl) ->
    return  if attr.type is "radio" or attr.type is "checkbox"

    elm.bind "blur", ->
      scope.$apply ->
        if EMAIL_REGX.test(elm.val())
          ctrl.$setValidity "emails", true
        else
          ctrl.$setValidity "emails", false


app.controller "UserSelectorCtrl", ($scope, $modalInstance, $timeout, User, LinkedInProfile, currentAccountId, entityLabel, isAuthenticatedToLinkedIn, enableLinkedIn, existingUserSelectable, selectedPersonForUpdate, existingPersons, saveOnce) ->
  ###
  DESCRIPTION: UserSelectorCtrl more accurately should be considered a "person" selector as the result
                may not be a User.  The purpose of the component is to allow a user to identify "person(s)" to add
                to one of the many lists of "persons" GreatHires keeps track of such as:
                List of Invitees, List of Candidates, List of Job Team Members, etc.

  USAGE: UserSelector is rendered as a "dialog" layer and instantiated as an Angular Bootstrap modal.
          The caller passes in the parameters below to control the behavior which can vary depending on intended use of the person criteria.

  ENTITY: Person
    A Person is simply the criteria used to identify an existing user, an existing LinkedIn person, or used to send to the backend to create a new
    User, Candidate, etc.  A Person object should not be considered or referred to as a User as it may reference an actual GreatHires User object; but in
    many cases is may not.
    Example Person entity:
     {"first":"John",
       "email":"human@oneandzero.com",
       "last":"Lorance",
       "id":null,
       "linkedin_id":"T63fETTfEi",
       "linkedin_profile":{},}


  PARAMETERS:
    entityLabel: String value is used a a label for buttons and dialog titling.
    currentAccountId: Integer value is used to scope User queries when attempting to match Person criteria to existing Users.
    isAuthenticatedToLinkedIn: Boolean value that controls whether or not extended LinkedIn information can be retrieved.
    enableLinkedIn: Boolean value which controls display of controls to search LinkedIn profiles.
    existingUserSelectable: If True, allows user to select a result from the existing user search results and allows return of item to caller.
                            If False, prevents user from selecting any item from the existing user search results and prevents matching users from returning to caller.
    selectedPersonForUpdate: A single Person object used for editing person information using the dialog. JS object is: {first, last, and email}
    existingPersons: An array of Person objects which are used to prevent the user from specifying person criteria that already matches existing items in the list
                      to which an attempt is being made to ad to.
    saveOnce: If True, only show 'Save' and 'Close' buttons. If false, show 'Save' and 'Save and Continue' buttons

  RESPONSIBILITIES:  It is the responsibility of the UserSelector module to ensure that:
                      a) New Persons do not exist in the list of existingPersons passed in.
                      b) If existingUserSelectable==False, then Person criteria must not match any existing users for the currentAccount
  ###

  $scope.account_id = currentAccountId
  $scope.entityLabel = entityLabel
  $scope.isAuthenticatedToLinkedIn = isAuthenticatedToLinkedIn
  $scope.isLinkedInControlEnabled = enableLinkedIn
  $scope.existingUserSelectable = existingUserSelectable
  $scope.saveOnce = saveOnce
  
  $scope.user = selectedPersonForUpdate
  $scope.isNew = !selectedPersonForUpdate.email?

  $scope.userTemplate =
    first: ""
    last: ""
    email: ""
    id: ""
    linkedin_id: ""
    linkedin_profile: ""

  $scope.alerts = []
  $scope.suggestions = []
  # field name for which build suggestions
  $scope.activeField = null
  $scope.linkedin_profiles = []
  $scope.isLinkiedInSearchActive = false

  # acceptedPersons holds the list of accepted persons that eventually gets handed back to the caller.
  $scope.acceptedPersons = []

  $scope.setFormScope =(form)->
    $scope.form = form

  $scope.reset =->
    $scope.user = angular.copy $scope.userTemplate
    $scope.form.userForm.$setPristine() if $scope.form
    $scope.linkedin_profiles = []


  acceptPerson = (person) ->
    # if update action
    person["isUpdating"] = true if !$scope.isNew
    
    $scope.acceptedPersons.push(person)
    $scope.reset()

  validateFields = ->
    form = $scope.form.userForm
    isValid = true
    if form.first.$invalid
      isValid = false
      $scope.form.userForm.first.$pristine = false;
    if form.last.$invalid
      isValid = false
      $scope.form.userForm.last.$pristine = false;
    if form.email.$invalid || $scope.form.userForm.$error.emails
      $scope.form.userForm.$error.emails = true
      $scope.form.userForm.email.$pristine = false;
      isValid = false
    return isValid

  # Check form validation
  $scope.isInvalid = ->
    form = $scope.form.userForm
    form.first.$invalid || form.last.$invalid || form.email.$invalid


  #$scope.saveAndClose = ()->
  #  $scope.save()
    # close and hand back list of newly added persons
  #  $modalInstance.close($scope.acceptedPersons)

  # $scope.save is triggered by a user action and is responsible to determining if new person criteria is acceptable or not.
  $scope.save = (close=false)->
    # Reset alerts
    $scope.alerts = []

    return if validateFields() == false

    # check existingPersons is undefined
    existingPersons = [] if not existingPersons?

    # Before considering this a valid person to add, ensure they are not found in the existing person's list already
    if $scope.isNew && existingPersons.find((p)-> p.email == $scope.user.email)?
      $scope.alerts.push({type: 'danger', msg: "You have already added this person."})
      return

    # Before considering this a valid person to add, ensure they are not in the new list of accepted users.
    if $scope.isNew && $scope.acceptedPersons.find((p)-> p.email == $scope.user.email)?
      $scope.alerts.push({type: 'danger', msg: "You have already added this person."})
      return

    # If its ok for the person criteria to match an existing user, simply add the new person to the accepted person's list.
    if !existingUserSelectable
      console.log "-- in existingUserSelectable, user=" + JSON.stringify($scope.user)
      acceptPerson($scope.user)
      $scope.alerts.push({type: 'success', msg: "#{entityLabel} was added successfully"})
      $modalInstance.close($scope.acceptedPersons) if close
    else
      # otherwise, if its not ok that person criteria matches an existing user, show message.
      # Attempt to find matching user, show message if matched; otherwise, its ok to add new person to the accepted person's list.
      User.all($scope.account_id, {email: $scope.user.email})
      .then (res)->
        if res.length > 0
          $scope.alerts.push({type: 'danger', msg: "This person is already associated with this account. Please go to Manage Users to manage this person."})
          return

        # If no Users match person criteria, then its ok to hand back.
        acceptPerson($scope.user)
        $modalInstance.close($scope.acceptedPersons) if close


  $scope.closeModal = ()->
    $modalInstance.close($scope.acceptedPersons)

  $scope.closeAlert = ->
    $scope.alerts = []

  # delay timer to prevent real-time ajax search
  delayTimer = null

  # auto-suggest controls
  $scope.searchSuggestions = (name, val)->
    return if val == undefined

    # Delay for search on typing in form field
    $timeout.cancel(delayTimer)
    
    delayTimer = $timeout ->
      params = {}
      params[name] = val
      User.all($scope.account_id, params)
      .then (res)->
        $scope.suggestions = []
        angular.forEach res, (item)-> $scope.suggestions.push(item)
        $scope.activeField = name 

      .catch (errorResponse) ->
        console.log "errorResponse = " + errorResponse
        []
      
    , 500

  $scope.hideSuggestions = ->
    $timeout ->
      $scope.activeField = null
    , 200

  $scope.isActiveBy = (fieldName)->
    $scope.activeField is fieldName

  $scope.selectSuggestion = (suggestion)->
    # return if progressive search
    return if !existingUserSelectable

    $scope.user = suggestion
    # load profile data if need
    if $scope.isLinkedInControlEnabled
      User.get($scope.user.id)
      .then (res)->
        $scope.linkProfileWithUser(res.linkedin_profile) if res.linkedin_profile?

      .catch (errorResponse) ->
        console.log "errorResponse = " + errorResponse
        []

    $scope.hideSuggestions()

  # LinkedIn controls
  $scope.isFirstAndLastArePopulated =->
    ($scope.user.first != "" && $scope.user.last != "")

  $scope.resetLinkedInSearchIfNeed =->
    $scope.user.id = null
    $scope.user.linkedin_id = null
    $scope.user.linkedin_profile = null
    $scope.isLinkiedInSearchActive = false

  $scope.findLinkedInProfile = ->
    LinkedInProfile.all($scope.account_id, $scope.user.first, $scope.user.last)
    .then (res)->
      $scope.isLinkiedInSearchActive = true
      $scope.linkedin_profiles = res
    .catch (errorResponse) ->
      if errorResponse.status is 401 or errorResponse.status is 422
        $scope.alerts = []
        $scope.alerts.push({type: 'danger', msg: errorResponse.data})

      console.debug errorResponse.status, errorResponse.data
      []

  $scope.linkProfileWithUser = (profile)->
    $scope.user.linkedin_id = profile.id
    $scope.user.linkedin_profile = profile
    $scope.isLinkiedInSearchActive = false

  $scope.getLinkedinUrl = ->
    Routes.user_omniauth_authorize_path('linkedin')
    
  $scope.reset() if $scope.isNew


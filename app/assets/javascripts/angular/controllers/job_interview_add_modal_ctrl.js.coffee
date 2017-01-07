app.controller "JobInterviewAddModalCtrl", ($scope, $modal, $modalInstance, $timeout, JobInterview, currentAccount, currentUser, currentJobId, candidateId, existingInterviews, interviewToUpdate, interviewRounds, interviewOptions, canAddHiringManagerNote) ->
  $scope.currentUser = currentUser
  $scope.currentJobId = currentJobId
  $scope.candidateId = candidateId
  $scope.existingInterviews = existingInterviews
  $scope.canAddHiringManagerNote = canAddHiringManagerNote

  $scope.interview_rounds = interviewRounds
  $scope.interview_options = interviewOptions

  $scope.isNew = !interviewToUpdate?
  $scope.alerts = []

  if interviewToUpdate?
    $scope.interview = interviewToUpdate

    # Get hour, min, meridian from start_time
    time_items = $scope.interview.start_time.split(":")
    $scope.start_time = 
      hour: time_items[0]
      min: time_items[1].substring(0, 2)
      meridian: time_items[1].substring(3)

  else
    $scope.interview = 
      interview_round_id: interviewRounds[0].id
      minutes_long: 15
      job_candidate_id: $scope.candidateId
      scheduled_at: new Date()
    $scope.start_time = 
      hour: 1
      min: "00"
      meridian: "AM"

  # -----------scope actions-----------
  $scope.setFormScope =(form)->
    $scope.form = form

  $scope.reset =->
    if $scope.isNew
      $scope.interview = 
        interview_round_id: interviewRounds[0].id
        minutes_long: 15
        job_candidate_id: $scope.candidateId
        scheduled_at: new Date()
        timezone_name: $scope.interview.timezone_name

      $scope.start_time = 
        hour: 1
        min: "00"
        meridian: "AM"
    $scope.chooseInterviewOption($scope.interview_options.find((option)-> option.id == $scope.interview.interview_type_id))

    $scope.form.interviewForm.$setPristine() if $scope.form

  # Trigger Date picker open event when user clicks datepicker control
  $scope.openDatepicker = ($event) ->
    $event.stopPropagation()
    $event.preventDefault()
    $scope.pickerOpened = true
    return
  $scope.closeModal = ()->
    $modalInstance.close($scope.acceptedPersons)

  # Choose interview option
  $scope.chooseInterviewOption = (option=null) ->
    if option == null || option == undefined
      $scope.currentInterviewOption = "an Interview"
      $scope.interview.interview_type_id = null
    else
      if option.name.charAt(0).match(/[aeiouAEIOU]/)?
        prefix = "an "
      else
        prefix = "a "

      $scope.currentInterviewOption = prefix + option.name
      $scope.interview.interview_type_id = option.id
    $scope.opened = false


  getInterviewStartTime = ->
    "#{$scope.start_time.hour}:#{$scope.start_time.min} #{$scope.start_time.meridian}"

  # ---------Add interview--------------
  $scope.save = (close=true)->
    $scope.alerts = []
    if !$scope.interview.scheduled_at?
      $scope.alerts.push({type: 'danger', msg: "Pick a date to schedule."})
      return
    if $scope.interview.interview_type_id == null && !$scope.interview.interviewer?
      $scope.interviewerPicked = false
      return

    if interviewToUpdate? # update job interview

      # Generate start_time from units
      $scope.interview.start_time = getInterviewStartTime()

      JobInterview.update($scope.interview) \
      .then (resource) ->
        $modalInstance.close(resource)

      .catch (errorResponse) ->
        console.log(errorResponse)

    else
      # Create Job interview
      
      # Generate start_time from units
      $scope.interview.start_time = getInterviewStartTime()

      JobInterview.create($scope.currentJobId, $scope.interview) \
      .then (resource) ->
        $scope.existingInterviews.push resource
        if close
          $modalInstance.close()
        else
          $scope.reset()

      .catch (errorResponse) ->
        console.log(errorResponse)

  # Open user selector modal to pick interviewer
  $scope.chooseInterviewer = ->
    currentRole = currentAccount.roles.find((role)-> role.name is "Interviewer")
    
    interviewer = $scope.interview.interviewer
    if interviewer?
      personToUpdate = 
        first: interviewer.first
        last: interviewer.last
        email: interviewer.email
        linkedin_id: interviewer.linkedin_id
        linkedin_profile: interviewer.linkedin_profile
    else
      personToUpdate = {}

    params =
      entityLabel: -> currentRole.name
      currentAccountId: -> currentAccount.id
      isAuthenticatedToLinkedIn: -> currentUser.is_authenticated_to_linkedIn
      enableLinkedIn: -> true
      existingUserSelectable: -> true
      selectedPersonForUpdate: -> personToUpdate
      existingPersons: -> []
      saveOnce: -> true

    options =
      templateUrl:  "components/user_selector.html"
      controller: 'UserSelectorCtrl'
      size: 'lg' if currentUser.is_authenticated_to_linkedIn # use small size if modal contains only warning message
      resolve: params
      backdrop: 'static'

    modalInstance = $modal.open options

    modalInstance.result
    .then (persons) ->
      persons.each((person) ->        
        $scope.interview.interviewer = person
      )
      $scope.interviewerPicked = true
      
    .catch () ->
      console.log "-- Returned from closed modal, in . catch"


  # Get current Interview Option
  $scope.chooseInterviewOption($scope.interview_options.find((option)-> option.id == $scope.interview.interview_type_id))

  $scope.reset()


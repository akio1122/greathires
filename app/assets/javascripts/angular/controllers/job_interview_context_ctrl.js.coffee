 app.controller "JobInterviewContextCtrl", ($scope, $stateParams, $location, $modal, JobCandidate, Candidate, JobInterviewGuide, LinkedInProfile, Note) -> 

  # preload_resources is from ng-init of content ui-view
  $scope.current_account = $scope.preload_resources?.account || null
  $scope.current_user = $scope.preload_resources?.current_user || null
  $scope.resource = $scope.preload_resources?.resource || null
  $scope.job_roles = $scope.preload_resources?.job_roles
  $scope.candidate_id = $stateParams.id
  $scope.previous_positions = ""
  $scope.hiring_manager_note = null

  # Open modal for social and attachment files 
  $scope.openSocialAndAttachmentModal = ->
    modalInstance = $modal.open(
      templateUrl:  "job_candidate_summary/add_social_and_resume.html"
      controller: 'CandidateSocialAndAttachmentModalCtrl'
      resolve:
        currentAccountId: -> $scope.current_account.id
        candidateToUpdate: -> $scope.job_candidate.candidate
        jobCandidate: -> $scope.job_candidate
    )
  
  getLinkedinPreviousPositions = (positions) ->
    $scope.previous_positions = positions.values.filter((position) -> position.isCurrent == false)
    .map((position) -> position.company.name).join(",")


  # Change candidate
  $scope.openCandidateModal = () ->
    $scope.current_role = $scope.current_account.roles.find((role)-> role.name is "Candidate")
    candidate = $scope.job_candidate.candidate
    if candidate?
      personToUpdate = 
        first: candidate.first
        last: candidate.last
        email: candidate.email
        linkedin_id: candidate.linkedin_id
        linkedin_profile:
          id: candidate.linkedin_id
          firstName: candidate.first
          lastName: candidate.last
          pictureUrl: candidate.linkedin_picture_url
          publicProfileUrl: candidate.linkedin_public_profile_url
    else
      personToUpdate = {}

    params =
      entityLabel: -> $scope.current_role.name
      currentAccountId: -> $scope.current_account.id
      isAuthenticatedToLinkedIn: -> $scope.current_user.is_authenticated_to_linkedIn
      enableLinkedIn: -> true
      existingUserSelectable: -> true
      selectedPersonForUpdate: -> personToUpdate
      existingPersons: -> []
      saveOnce: -> false

    options =
      templateUrl:  "components/user_selector.html"
      controller: 'UserSelectorCtrl'
      size: 'lg' if $scope.current_user.is_authenticated_to_linkedIn     # use small size if modal contains only warning message
      resolve: params
      backdrop: 'static'

    modalInstance = $modal.open options

    modalInstance.result
    .then (persons) ->
      persons.each((person) ->        
        if person.isUpdating? 
          editCandidate(person)
      )
      
      # console.log JSON.stringify(persons)
    .catch () ->
      console.log "-- Returned from closed modal, in . catch"

  $scope.saveHiringManagerNote = ->
    attrs = 
      text: $scope.hiring_manager_note
      kind: "kind_manager_note"
      job_candidate_id: $scope.job_candidate.id

    Note.create(attrs)
    .then (resource)->
      $scope.job_candidate.notes = [] if !$scope.job_candidate.notes?
      $scope.job_candidate.notes.push(resource)
      $scope.hiring_manager_note = null
    .catch (errorResponse)->
      console.log "Error Response of Edit Candidate : " + errorResponse


  # edit Candidate for linkedin
  editCandidate = (candidate) ->
    attrs = 
      id: $scope.job_candidate.candidate.id
      first: candidate.first
      last: candidate.last
      email: candidate.email

    if candidate.linkedin_profile?
      attrs['linkedin_id'] = candidate.linkedin_profile.id
      attrs['linkedin_public_profile_url'] = candidate.linkedin_profile.publicProfileUrl
      attrs['linkedin_picture_url'] = candidate.linkedin_profile.pictureUrl
    else
      attrs['linkedin_id'] = "";
      attrs['linkedin_public_profile_url'] = "";
      attrs['linkedin_picture_url'] = "";

    Candidate.update($scope.current_account.id, attrs)
    .then (resource)->
      $scope.job_candidate.candidate = resource
      
      # Get linkedin detail
      if attrs.linkedin_id != ""
        LinkedInProfile.get(attrs.linkedin_id)
        .then (profile) ->
          $scope.job_candidate.linkedin_profile = profile
          getLinkedinPreviousPositions(profile.positions)

    .catch (errorResponse)->
      $scope.job_candidate.linkedin_profile = null
      $scope.previous_positions = ''
      console.log "Error Response of Edit Candidate : " + errorResponse



  # Retrieve candidate info to show candidate info in nav
  getJobCandidate = ->
    JobCandidate.get($scope.candidate_id)
    .then (resource) ->
      $scope.job_candidate = resource
      console.log(resource)
      
      # Get linkedin detail
      LinkedInProfile.get(resource.candidate.linkedin_id)
      .then (profile) ->
        $scope.job_candidate.linkedin_profile = profile
        getLinkedinPreviousPositions(profile.positions)

    .catch (errorResponse) -> console.log "JobCandidate.get, error=" + errorResponse

  getJobCandidate()

  # --- HELPER METHODS ---
  $scope.getImageUrl = (url) ->
    if url == null || url == ""
      return '/assets/blank.png'
    else
      url

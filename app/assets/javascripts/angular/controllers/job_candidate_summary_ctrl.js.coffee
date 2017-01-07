app.controller "JobCandidateSummaryCtrl", ["$scope", "$modal", "$stateParams", "$location", "Account", "Job", "Candidate", "JobCandidate", \
                            ($scope, $modal, $stateParams, $location, Account, Job, Candidate, JobCandidate) ->

  # --- Internal Use Variables ---

  # --- Scoped Variables ----
  $scope.candidates = []
  $scope.predicate = "candidate.last" # order by
  $scope.reverse = false # order asc or desc
  $scope.no_interviews = false

  $scope.currentCandidate = null # index is used for edit candidate
  # --- Methods --- 
  # retrieve job candidate list
  getAllCandidates = () ->    
    JobCandidate.all($scope.resource.id) \
    .then (resources) ->      
      if resources.length is 0
        $scope.no_interviews = true
      else
        $scope.no_interviews = false

      $scope.candidates = resources
    .catch (errorResponse) -> console.log "JobCandidateSummaryCtrl.index, error=" + errorResponse

  # Save Candidtes for the Job
  addCandidate = (user)->
    attrs =
      account_id: $scope.current_account.id
      first: user.first
      last: user.last
      email: user.email

    attrs['user_id'] = user.id if user.id?
    if user.linkedin_profile?
      attrs['linkedin_id'] = user.linkedin_profile.id
      attrs['linkedin_public_profile_url'] = user.linkedin_profile.publicProfileUrl
      attrs['linkedin_picture_url'] = user.linkedin_profile.pictureUrl if user.linkedin_profile.pictureUrl?

    Candidate.create($scope.current_account.id, attrs)
    .then (candidate)->
      # add candidate to current job
      JobCandidate.create($scope.resource.id, candidate.id)
      .then (job_candidate)->
        getAllCandidates()
      .catch (errorResponse)->
        console.log "Error Response of Job Candidate : " + errorResponse
    .catch (errorResponse)->
      console.log errorResponse

  # edit Candidate for linkedin
  editCandidate = (candidate) ->
    attrs = 
      id: $scope.currentCandidate.id
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
      getAllCandidates()
    .catch (errorResponse)->
      console.log "Error Response of Edit Candidate : " + errorResponse

  # --- Scoped Methods ---
  # $scope.init = (preload_resources) ->
  #   console.log "-- JobCandidateSummaryCtrl, $scope.preloaded=" + JSON.stringify(preload_resources)

  # preload_resources is from ng-init of content ui-view
  $scope.current_account = $scope.preload_resources?.account || null
  $scope.current_user = $scope.preload_resources?.current_user || null
  $scope.resource = $scope.preload_resources?.resource || null
  $scope.job_statuses = $scope.preload_resources?.account.job_statuses || null
  $scope.job_roles = $scope.preload_resources?.job_roles

  # filter candidates by status dropdownlist
  #$scope.statusFilter = (data) ->
  #  if(data.candidate_status_id is $scope.filter_status or not $scope.filter_status?)
  #    return true
  #  else
  #    return false

  # Popup Add Candidate Dialog with Linkedin Profile
  $scope.openCandidateModal = (candidate=null) ->
    $scope.current_role = $scope.current_account.roles.find((role)-> role.name is "Candidate")
    
    $scope.currentCandidate = candidate
    if candidate?
      # personToUpdate = angular.copy candidate #if updating pass in person to update.
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
        else
          addCandidate(person)
      )
      
      # console.log JSON.stringify(persons)
    .catch () ->
      console.log "-- Returned from closed modal, in . catch"

  # Job Update takes a resource and optional event object.
  $scope.update = (resource) ->
    Job.update(resource) \
    .catch (errorResponse) -> console.log "-- JobCandidateSummaryCtrl.update, errorResponse=" + errorResponse

  # update Candidate Status and Interview State
  $scope.updateCandidate = (candidate) ->
    JobCandidate.update($scope.resource.id, candidate.id, candidate)

  $scope.deleteCandidate = (candidate) ->
    JobCandidate.delete($scope.resource.id, candidate.id)
    
    index = $scope.candidates.indexOf(candidate)
    $scope.candidates.splice index, 1

  # Job Permission Checking
  $scope.checkPermission = (action) ->
    Job.checkPermission(action, $scope.job_roles, $scope.current_account.role_permissions)

  $scope.hiringManager = ->
    # Returns a hiring manager's name if there is one defined.
    #user_roles.each((item) -> console.log item.name)
    hm = $scope.job_roles.filter((item) -> item.name=="Hiring Manager")
    return hm[0]?.user_full_name || ""

  # permission checking
  $scope.can_edit = $scope.checkPermission "edit_candidates_and_interviews" # Can Edit Candidates & Interviews
  $scope.view_candidate_result = $scope.checkPermission "view_candidate_result" # View Candidate Results
  $scope.read_job_result = $scope.checkPermission "read_job_result" # View Job Results

  getAllCandidates()

]

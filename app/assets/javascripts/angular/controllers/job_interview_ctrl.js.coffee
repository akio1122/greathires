app.controller "JobInterviewCtrl", ($scope, $stateParams, $location, $modal, Job, JobInterview, InterviewRound, InterviewType, JobInterviewGuide) -> 
  # preload_resources is from ng-init of content ui-view
  $scope.current_account = $scope.preload_resources?.account || null
  $scope.current_user = $scope.preload_resources?.current_user || null
  $scope.resource = $scope.preload_resources?.resource || null
  $scope.job_statuses = $scope.preload_resources?.account.job_statuses || null
  $scope.job_roles = $scope.preload_resources?.job_roles
  $scope.candidate_id = $stateParams.id

  # --- Scope variables ---
  $scope.job_interviews = null
  $scope.job_candidate = {}
  $scope.interview_rounds = []
  $scope.interview_options = []
  $scope.job_interview_guides = []

  $scope.predicate = "candidate.last" # order by
  $scope.reverse = false # order asc or desc
  $scope.no_interviews = false
  $scope.isLoading = true # Flag to show loading animation

  # --- Methods --- 
  
  # retrieve job candidate list
  getAllInterviews = () ->    
    JobInterview.all($scope.candidate_id) \
    .then (resources) ->
      if resources.length is 0
        $scope.no_interviews = true
      else
        $scope.no_interviews = false

      $scope.job_interviews = resources
    .catch (errorResponse) -> console.log "JobInterviewCtrl.index, error=" + errorResponse


  # --- Scope Methods ---
  $scope.checkPermission = (action) ->
    Job.checkPermission(action, $scope.job_roles, $scope.current_account.role_permissions)

  # open job interview add modal
  $scope.openJobInterviewModal = (interview=null) ->

    if interview?
      interviewToUpdate = angular.copy interview #if updating pass in person to update.
    else
      interviewToUpdate = null

    modalInstance = $modal.open(
      templateUrl:  "job_interview/add_job_interview.html"
      controller: 'JobInterviewAddModalCtrl'
      resolve:
        currentAccount: -> $scope.current_account
        currentUser: -> $scope.current_user
        currentJobId: -> $scope.resource.id
        candidateId: -> $scope.candidate_id
        existingInterviews: -> $scope.job_interviews
        interviewToUpdate: -> interviewToUpdate
        interviewRounds: -> $scope.interview_rounds
        interviewOptions: -> $scope.interview_options
        canAddHiringManagerNote: -> $scope.can_add_hr_note
    )

    modalInstance.result
    .then (interview) ->
      if interview?
        index = $scope.job_interviews.findIndex((e)-> e.id == interview.id)
        $scope.job_interviews[index] = interview

    .catch () ->
      # User abandoned changes.
      console.log "-- Returned from closed modal, in . catch"

  $scope.editJobInterview = (job_interview) ->
    JobInterview.update(job_interview)
    .then (resource) ->
      console.log(resource)
    .catch (errorResponse) ->
      console.log(errorResponse)

  # Delete job interview
  $scope.deleteJobInterview = (item)->
    JobInterview.remove(item.id)
    .then (resource) ->
      index = $scope.job_interviews.findIndex((e)-> e.id == item.id)
      $scope.job_interviews.splice index, 1

  # Retrieve interview rounds
  getInterviewRounds = ->
    InterviewRound.all($scope.current_account.id)
    .then (resources) ->
      $scope.interview_rounds = resources
      console.log resources

  # Retrieve interview options
  getInterviewTypes = ->
    InterviewType.all($scope.current_account.id)
    .then (resources) ->
      $scope.interview_options = resources
      console.log resources

  getJobInterviewGuides = ->
    JobInterviewGuide.all($scope.resource.id)
    .then (resources) ->
      $scope.job_interview_guides = resources

  $scope.can_edit = $scope.checkPermission "edit_candidates_and_interviews" # Can Edit Candidates & Interviews
  $scope.can_add_hr_note = $scope.checkPermission "add_hiring_manager_notes" # Add Hiring Manager Note
  $scope.view_candidate_result = $scope.checkPermission "view_candidate_result" # View Candidate Results
  $scope.read_job_result = $scope.checkPermission "read_job_result" # View Job Results

  getInterviewTypes()
  getInterviewRounds()
  getJobInterviewGuides()

  getAllInterviews()

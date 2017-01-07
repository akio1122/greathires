app.controller "InterviewContentCtrl", ["$scope", "$modal", "$stateParams", "$filter", "JobCandidate", "Job", \
                            ($scope, $modal, $stateParams, $filter, JobCandidate, Job) ->
  # --- Internal Use Variables ---

  # --- Scoped Variables ----  
  $scope.current_user = $scope.preload_resources.current_user
  $scope.account = $scope.preload_resources.account
  $scope.job_interview = $scope.preload_resources.interview
  $scope.job_candidate = $scope.preload_resources.candidate
  $scope.job = $scope.preload_resources.job
  console.log $scope.job

  # Get interview schedule for previous, my current, and next
  $scope.interviews = $scope.job_candidate.job_interviews.sortBy (item)-> item.scheduled_at
  $scope.my_index = $scope.interviews.findIndex((e)-> e.id == $scope.job_interview.id)

  $scope.interview_schedule = $scope.interviews.groupBy (item)-> $filter('date')(item.scheduled_at, 'mediumDate')

  $scope.rating_handles = $scope.account.rating_scale_options.groupBy (item)-> item.handle

  # --- Methods --- 

  # --- Scoped Methods ---
  $scope.accountManager = () ->
    # Returns a account managers name if there is one defined.
    am = $scope.job.user_roles.filter((item) -> item.name=="Account Manager")
    return am[0]?.user_full_name || ""

  $scope.getInterviewName = (interview) ->
    if not interview.interviewer?
      return interview.interview_type.name
    else
      return interview.interviewer.full_name

  $scope.convertRatingTypeName = (rating_type) ->
    switch rating_type
      when "checkboxes"
        "checkbox"
      when "thumbs-up"
        "like"
      when "thumbs-up-down"
        "thumbs"

  $scope.getToday = () ->
    $filter('date')(new Date(), 'mediumDate')

  $scope.getListType = (numbered) ->
    if numbered
      "list-type-decimal"
    else
      "list-type-disc"
]

# rating controller
app.controller "InterviewRatingCtrl", ["$scope", "$modal", "$stateParams", "JobCandidateRating", \
                            ($scope, $modal, $stateParams, JobCandidateRating) ->

  $scope.initCtrl = (ratable, rating_options, type) ->
    $scope.ratable = ratable
    $scope.ratable_type = type
    $scope.rating_name = $scope.ratable_type + $scope.ratable.id

    # only rating, no comment for job specification
    $scope.rating = $scope.ratable.ratings?.findAll((item) -> item.comment == "").last()
    if not $scope.rating?
      $scope.rating =
        rating: 0

    $scope.rating_options = rating_options

  $scope.rating_click = (rating_scale_option_id, rating) ->
    rating = 0 if rating == $scope.rating.rating
    attrs = 
      job_candidate_id: $scope.job_candidate.id
      job_interview_id: $scope.job_interview.id
      ratable_type: $scope.ratable_type
      ratable_id: $scope.ratable.id
      rating_scale_option_id: rating_scale_option_id
      rating: rating
      comment: ""

    JobCandidateRating.create(attrs) \
    .then (resource) ->
      $scope.rating = resource
      $scope.ratable.ratings = [] if not $scope.ratable.ratings?
      $scope.ratable.ratings.push resource
    .catch (errorResponse) ->
      console.log  "errorResponse = " + errorResponse
]

app.controller "InterviewsCtrl", ["$scope", "$modal", "$state", "$stateParams", \
                            ($scope, $modal, $state, $stateParams) ->
  # --- Internal Use Variables ---

  # --- Scoped Variables ----  
  $scope.account = $scope.preload_resources.account
  $scope.resources = $scope.preload_resources.resources
  $scope.current_user = $scope.preload_resources.current_user

  # filter interviews by today, upcoming, and past
  $scope.today = []
  $scope.upcoming = []
  $scope.past = []

  $scope.resources.forEach (job) ->
    job.job_candidates.forEach (candidate) ->
      candidate.job_interviews.forEach (interview) ->
        if interview.interviewer?
          item =
            job_id : job.id
            job_title : job.name
            job_candidate_id : candidate.id
            picture_url : candidate.candidate.linkedin_picture_url
            candidate_name : candidate.candidate.full_name
            job_interview_id : interview.id
            interviewer_id : interview.interviewer_id
            interview_round : interview.interview_round.name
            scheduled_at : interview.scheduled_at
            start_time : interview.start_time
            end_time : interview.end_time
            location : interview.location

          # only compare date without time
          cur_date = new Date().setHours(0,0,0,0)
          input_date = new Date(interview.scheduled_at).setHours(0,0,0,0)
          if input_date > cur_date
            item.type = "upcoming"
            $scope.upcoming.push item
          else if input_date < cur_date
            item.type = "past"
            $scope.past.push item
          else
            item.type = "today"
            $scope.today.push item

  #  non-Interviews(candidate interviewing) will appear first (before scheduled interviews)
  $scope.today = $scope.today.sortBy (item)-> item.scheduled_at

  $scope.upcoming = $scope.upcoming.sortBy (item)-> item.scheduled_at
  $scope.past = $scope.past.sortBy (item)-> item.scheduled_at

  unless $scope.today.isEmpty()
    $state.transitionTo("app.today")
  else unless $scope.upcoming.isEmpty()
    $state.transitionTo("app.upcoming")
  else unless $scope.past.isEmpty()
    $state.transitionTo("app.past")
  else
    $state.transitionTo("app.today")

  # --- Methods --- 
  # --- Scoped Methods ---

]

app.controller "InterviewCandidateCtrl", ["$scope", "$modal", "$stateParams", "JobSkillQuestion", "JobCandidateRating", \
                            ($scope, $modal, $stateParams, JobSkillQuestion, JobCandidateRating) ->

  # --- Internal Use Variables ---

  # --- Scoped Variables ----  
  $scope.new_question = ""
  $scope.note = ""

  if $scope.account.job_skill_traits_ratable
    $scope.trait_rating_options = $scope.rating_handles[$scope.convertRatingTypeName($scope.account.job_skill_traits_rating_type)]
  else
    $scope.trait_rating_options = []

  if $scope.account.job_skill_questions_ratable
    $scope.question_rating_options = $scope.rating_handles[$scope.convertRatingTypeName($scope.account.job_skill_questions_rating_type)]
  else
    $scope.question_rating_options = []

  # --- Methods --- 

  # --- Scoped Methods ---
  $scope.saveNote = (question, note) ->
    attrs = 
      job_candidate_id: $scope.job_candidate.id
      job_interview_id: $scope.job_interview.id
      ratable_type: "job_skill_question"
      ratable_id: question.id
      #rating_scale_option_id: 1 # set temp value, no use in note
      #rating: 0 # set temp value, no use in note
      comment: note

    JobCandidateRating.create(attrs) \
    .then (resource) ->
      console.log resource
      resource.creator = $scope.current_user
      question.ratings = [] if not question.ratings?
      question.ratings.push resource
    .catch (errorResponse) ->
      console.log  "errorResponse = " + errorResponse

  $scope.saveQuestion = (skill, question) ->
    if question
      JobSkillQuestion.create(skill.id, question) \
      .then (resource) ->
        skill.job_skill_questions.push
          id: resource.id
          description: resource.description
      .catch (errorResponse) ->
        console.log  "errorResponse = " + errorResponse
]

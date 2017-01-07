app.controller "InterviewPrepareCtrl", ["$scope", "$modal", "$stateParams", \
                            ($scope, $modal, $stateParams) ->

  if $scope.account.job_spec_large_text_field_type
    $scope.item_rating_options = $scope.rating_handles[$scope.convertRatingTypeName($scope.account.job_spec_large_text_field_rating_type)]
  else
    $scope.item_rating_options = []

  if $scope.account.job_spec_questions_text_field_type
    $scope.question_rating_options = $scope.rating_handles[$scope.convertRatingTypeName($scope.account.job_spec_questions_text_field_rating_type)]
  else
    $scope.question_rating_options = []
]

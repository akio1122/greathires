app.controller "InterviewsListerCtrl", ["$scope", "$state", "$stateParams", \
                            ($scope, $state, $stateParams) ->

  # --- Internal Use Variables ---
  $scope.interviews = []

  sub_name = $state.current.url
  if sub_name is "today"
    $scope.interviews = $scope.today
    $scope.interviews_label = "interviews today"
  else if sub_name is "upcoming"
    $scope.interviews = $scope.upcoming
    $scope.interviews_label = "upcoming interviews"
  else
    $scope.interviews = $scope.past
    $scope.interviews_label = "past interviews"

  # --- Scoped Variables ----  

  # --- Methods --- 
  # --- Scoped Methods ---
]
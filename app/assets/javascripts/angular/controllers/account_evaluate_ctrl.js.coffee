app.controller "AccountEvaluateCtrl", ["$scope", "$state", "$stateParams", "$location", "Account", "RatingScaleOption", \
                            ($scope, $state, $stateParams, $location, Account, RatingScaleOption) ->


  $scope.loadRatingScaleOptions = ()->
    RatingScaleOption.all($scope.account.id, active: 'all')
    .then (responses) ->
      $scope.account.rating_scale_options = responses.groupBy (item)-> item.handle
      console.log $scope.account.rating_scale_options
      $scope.account.overall = $scope.account.rating_scale_options.overall
      $scope.account.job_skills_ratings = $scope.account.rating_scale_options['job-skills']

    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.updateRatingScaleOption = (item)->
    attrs = 
      active: item.active
      name: item.name

    RatingScaleOption.update item.id, $scope.account.id, attrs
    .then (response) ->
      console.log 'Ok'
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  # initialize
  $scope.loadRatingScaleOptions() unless $scope.account.rating_scale_options?
]
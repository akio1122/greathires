app.controller "CandidateSocialAndAttachmentModalCtrl", ($scope, $window, $modalInstance, $timeout, Candidate, currentAccountId, candidateToUpdate, jobCandidate) ->

  $scope.candidate = candidateToUpdate
  $scope.job_candidate = jobCandidate
  $scope.current_account_id = currentAccountId
  
  $scope.urlsOnEdit = 
  	linkedin_public_profile_url: !$scope.candidate.linkedin_public_profile_url?
  	twitter_profile_url: !$scope.candidate.twitter_profile_url?
  	facebook_profile_url: !$scope.candidate.facebook_profile_url?
  	github_profile_url: !$scope.candidate.github_profile_url?

  # Return visibility of social input field
  $scope.isVisible = (field) ->
    return true if !$scope.candidate[field]? || $scope.candidate[field] == "" || $scope.urlsOnEdit[field] == true
    return false

  $scope.clearUrl = (url) ->
  	$scope.candidate[url] = null
  	$scope.updateSocialFields()


  # update social fields
  $scope.updateSocialFields = (url)->
    Candidate.update(currentAccountId, $scope.candidate)
    .then (resource)->
      $scope.candidate = resource
      $scope.urlsOnEdit[url] = false
    .catch (errorResponse)->
      console.log "Error Response of Edit Candidate : " + errorResponse

  $scope.closeModal = ()->
    $modalInstance.dismiss 'cancel'
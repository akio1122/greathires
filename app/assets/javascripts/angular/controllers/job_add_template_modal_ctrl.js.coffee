app.controller "JobAddTemplateModalCtrl", ($scope, $window, $modalInstance, $timeout, Job, resource) ->

  # --- Internal Use Variables ---

  # --- Scoped Variables ----
  $scope.resource = resource
  $scope.validation_errors = []

  # --- Methods --- 

  # --- Scoped Methods ---
  $scope.setFormScope = (form)->
    $scope.form = form

  $scope.saveJobTemplate = () ->
    $scope.validation_errors["name"] = []
    $scope.resource.is_template = true
    Job.update($scope.resource) \
    .then (response) ->
      $scope.closeModal()
    .catch (errorResponse) ->
      console.log errorResponse
      if errorResponse.status is 401 or errorResponse.status is 422       
        angular.forEach errorResponse.data.errors, (error)->
          $scope.form.jobTemplateForm["name"].$setValidity("serverError", false)
          $scope.validation_errors["name"].push(error)

  $scope.closeModal = ()->
    $modalInstance.dismiss 'cancel'
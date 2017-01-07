app.controller "AccountJobSpecificationsCtrl", ["$scope", "$state", "$stateParams", "$location", "Account", "Specification", "Classification", "ClassificationOption", \
                            ($scope, $state, $stateParams, $location, Account, Specification, Classification, ClassificationOption) ->

  $scope.updateJobSpecificationsFeatures = ->
    # set default type if large text field not ratable
    if !$scope.account.job_spec_large_text_field_type
      $scope.account.job_spec_large_text_field_rating_type = 'thumbs-up'

    # set default values if question option is unchecked
    if !$scope.account.job_spec_questions_enabled
      $scope.account.job_spec_questions_text_field_type = false
      $scope.account.job_spec_questions_numbered = false

    # set default type if questions text field not ratable
    if !$scope.account.job_spec_questions_text_field_type
      $scope.account.job_skill_questions_rating_type = 'thumbs-up'

    $scope.updateAccountPreferences()

  $scope.loadSpecifications = ()->
    Specification.all($scope.account.id, active: 'all')
    .then (responses) ->
      $scope.account.specifications = responses
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.validateSpecification = (name)->
    return 'Name is required' if name.isBlank()
    # validate by uniq name
    status = $scope.account.specifications.find (item)-> name == item.name
    return 'Name is already taken' if status?

  $scope.createSpecification = (name)->
    # reset form
    $scope.new_specification = ""
    attrs = 
      active: true
      name: name
      account_id: $scope.account.id

    Specification.create $scope.account.id, attrs
    .then (response) ->
      $scope.account.specifications.push response
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.updateSpecification = (item)->
    attrs = 
      active: item.active
      name: item.name

    Specification.update item.id, $scope.account.id, attrs
    .then (response) ->
      console.log 'Ok'
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.deleteSpecification = (item)->
    Specification.remove item.id
    .then (response) ->
      index = $scope.account.specifications.indexOf(item)
      $scope.account.specifications.splice index, 1

    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  # Classification Specification
  $scope.loadClassifications = ()->
    Classification.all($scope.account.id, active: 'all')
    .then (responses) ->
      $scope.account.classifications = responses
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.validateClassification = (name)->
    return 'Name is required' if name.isBlank()
    # validate by uniq name
    status = $scope.account.classifications.find (item)-> name == item.name
    return 'Name is already taken' if status?

  $scope.createClassification = (name)->
    # reset form
    $scope.new_classification = ""
    attrs = 
      active: true
      name: name
      account_id: $scope.account.id

    Classification.create $scope.account.id, attrs
    .then (response) ->
      $scope.account.classifications.push response
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.updateClassification = (item)->
    attrs = 
      active: item.active
      name: item.name

    Classification.update item.id, $scope.account.id, attrs
    .then (response) ->
      console.log 'Ok'
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.deleteClassification = (item)->
    Classification.remove item.id
    .then (response) ->
      index = $scope.account.classifications.indexOf(item)
      $scope.account.classifications.splice index, 1

    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.validateClassificationOption = (name, classification_id)->
    return 'Name is required' if name.isBlank()
    # validate by uniq name
    status = $scope.account.classifications.find (item)-> name == item.name && classification_id == item.classification_id
    return 'Name is already taken' if status?

  $scope.createClassificationOption = (name, classification_id)->
    # reset form
    $scope.new_classification_option = ""

    attrs = 
      active: true
      name: name
      classification_id: classification_id
      account_id: $scope.account.id

    ClassificationOption.create $scope.account.id, attrs
    .then (response) ->
      classification = $scope.account.classifications.find (item)-> item.id == classification_id
      classification.classification_options = [] unless classification.classification_options?
      classification.classification_options.push response
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.updateClassificationOption = (item)->
    attrs = 
      active: item.active
      name: item.name

    ClassificationOption.update item.id, $scope.account.id, attrs
    .then (response) ->
      console.log 'Ok'
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.deleteClassificationOption = (item, classification_id)->
    ClassificationOption.remove item.id
    .then (response) ->
      classification = $scope.account.classifications.find (item)-> item.id == classification_id
      index = classification.classification_options.indexOf(item)
      classification.classification_options.splice index, 1

    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  # initialize
  $scope.loadSpecifications() unless $scope.account.specifications?
  $scope.loadClassifications() unless $scope.account.classifications?

]
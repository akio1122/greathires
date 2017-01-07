app.controller "AccountJobSkillCtrl", ["$scope", "$state", "$stateParams", "$location", "Account", "Skill", \
                            ($scope, $state, $stateParams, $location, Account, Skill) ->

  $scope.updateJobSkillsFeatures = ->
    # set default type if large text field not ratable
    if !$scope.account.job_skill_traits_ratable
      $scope.account.job_skill_traits_rating_type = 'thumbs-up'

    # set default values if question option is unchecked
    if !$scope.account.job_skill_questions_enabled
      $scope.account.job_skill_questions_ratable = false
      $scope.account.job_skill_questions_numbered = false
      $scope.account.job_skill_questions_comments_enabled = false

    # set default type if questions text field not ratable
    if !$scope.account.job_skill_questions_ratable
      $scope.account.job_skill_questions_rating_type = 'thumbs-up'

    $scope.updateAccountPreferences()

  $scope.loadSkills = ()->
    Skill.all($scope.account.id, active: 'all')
    .then (responses) ->
      $scope.account.skills = responses
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.validateSkill = (name)->
    return 'Name is required' if name.isBlank()
    # validate by uniq name
    status = $scope.account.skills.find (item)-> name == item.name
    return 'Name is already taken' if status?

  $scope.createSkill = (name)->
    $scope.new_skill = ""
    Skill.save $scope.account.id, name
    .then (response) ->
      $scope.account.skills.push response
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.updateSkill = (item)->
    attrs = 
      active: item.active
      name: item.name

    Skill.update item.id, $scope.account.id, item.name, item.active
    .then (response) ->
      console.log 'Ok'
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  $scope.deleteSkill = (item)->
    Skill.remove item.id
    .then (response) ->
      index = $scope.account.skills.indexOf(item)
      $scope.account.skills.splice index, 1

    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse

  # initialize
  $scope.loadSkills() unless $scope.account.skills?
]
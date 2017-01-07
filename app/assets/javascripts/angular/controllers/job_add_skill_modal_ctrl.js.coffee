app.controller "JobAddSkillModalCtrl", ($scope, $window, $modalInstance, $timeout, Job, Skill, JobRole, JobSkill, account_id, job_id, job_skills, all_skills) ->

  # --- Internal Use Variables ---

  # --- Scoped Variables ----  
  $scope.filter = ""
  $scope.all_skills = all_skills
  $scope.new_skill = ""
  $scope.validation_errors = []

  $scope.range = [] # filter skills by first character

  $scope.avail_skills = []
  # get list of non-selected Job Skills sorted in alphabetical order
  for skill in $scope.all_skills    
    job_skill = job_skills.find((item) -> item.skill_id is skill.id)
    if(!job_skill)
      skill.checked = false
      $scope.avail_skills.push(skill)

  # --- Methods --- 
  setFilter = () ->
    $scope.range = []
    $scope.avail_skills.forEach (item) ->
      character = item.name.substring(0, 1)
      if $scope.range.indexOf(character) is -1
        $scope.range.push character  
  setFilter()

  # --- Scoped Methods ---
  $scope.setFormScope = (form) ->
    $scope.form = form

  $scope.closeModal = (close) ->
    if(close)
      $modalInstance.close([])
    else
      $modalInstance.close($scope.avail_skills.findAll((item) -> item.checked is true))

  $scope.addSkill = () ->
    $scope.validation_errors["name"] = []
    if($scope.new_skill isnt "")
      if($scope.all_skills.find((item) -> item.name is $scope.new_skill))
        $scope.form.skillForm["name"].$setValidity("serverError", false)
        $scope.validation_errors["name"].push("Skill name already exists")
      else
        resource =
          id: 0
          name: $scope.new_skill
          checked: true

        $scope.all_skills.push(resource)
        $scope.avail_skills.push(resource)
        $scope.new_skill = ""

        setFilter()

  # filter skills
  $scope.filterSkills = (n, $event) ->
    $event.preventDefault()
    if n is -1
      $scope.filter = "" 
    else
      $scope.filter = n
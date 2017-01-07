
app.controller "JobNavigatorCtrl", ["$scope", "$modal", "$stateParams", "Job", "Skill", "JobSkill", \
                                    ($scope, $modal, $stateParams, Job, Skill, JobSkill) ->

  $scope.account = $scope.preload_resources?.account || $scope.loadAccount()
  $scope.resource = $scope.preload_resources?.resource || null

  skillsToAdd = (job_skills, skills) ->
    # Clone incoming array so as not to affect the data source directly as we're essentially subtracting values out of array.
    new_array = skills.clone()
    # For each item in the "items_to_remove" list, find it and remove it from the new array.
    # cannot use SugarJS's delete because that triggers a Restangular delete.
    # Angular equals not used here since objects may not be exactly of the same type but still reference the same object id.
    job_skills.each((existing_skill) ->  new_array = new_array.findAll((skill) -> existing_skill.skill_id!=skill.id))
    new_array

  $scope.job_skills_label = () ->
    $scope.account.job_skills_label

  # ### MODAL RELATED ITEMS HERE
  $scope.openSkillsModal = ($event) ->
    $event.preventDefault()
    $event.stopPropagation()

    Skill.all($scope.account.id).then (resources) ->
      modalInstance = $modal.open
        templateUrl: 'job_editor/add_skill.html',
        controller: 'JobAddSkillModalCtrl',
        size: 'sm',
        backdrop: 'static'
        resolve:
          account_id: -> $scope.account.id
          job_id: -> $scope.resource.id
          job_skills: -> return $scope.resource.job_skills
          all_skills: -> return resources

      modalInstance.result
      .then (new_skills) ->
        new_skills.each (item) ->
          if item.id is 0
            # Add Job Skill
            Skill.save($scope.account.id, item.name)
            .then (skill) ->
              JobSkill.save($scope.resource.id, skill.id)
              .then (resource) ->
                $scope.resource.job_skills.push(resource)
              .catch (errorResponse) ->
                console.log "New Job Skill Save Failed"  
            .catch (errorResponse) -> 
              console.log "New Skill Save Failed"
          else
            # Update Job Skill for enable
            JobSkill.save($scope.resource.id, item.id)
            .then (resource) ->
              $scope.resource.job_skills.push(resource)
            .catch (errorResponse) ->
              console.log "Got Error - Job Skill Save"

      .catch () -> console.log "modal rejected"

  # Job Permission Checking
  $scope.checkPermission = (action) ->
    Job.checkPermission(action, $scope.resource.user_roles, $scope.account.role_permissions)

  $scope.can_edit = $scope.checkPermission("update_job")
]

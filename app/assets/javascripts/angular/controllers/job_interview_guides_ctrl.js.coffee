app.controller "JobInterviewGuidesCtrl", ($scope, $stateParams, $state, Job, JobSkill, JobInterviewGuide) ->
  $scope.job = $scope.resource
  $scope.previous_interview_guides_count = 0
  $scope.skills = []

  $scope.isSkillLoaded = false

  $scope.numbers = [1,2,3,4,5,6,7,8,9,10]

  $scope.buildInterviewGuides = ->
    $scope.interview_guides = []
    for num in [1..$scope.job.interview_guides_count]
      item = JobInterviewGuide.new({job_id: $scope.job.id, num: num, title: $scope.getJobInterviewGuides() })
      $scope.interview_guides.push item

  $scope.saveInterviewGuide = (skill) ->
    # TODO: front-end uniq
    index = skill.interview_guides.length - 1
    guide = skill.interview_guides[index]

    unless guide.id?
      guide.job_skill_id = skill.id
      guide.save({job_skill_id: skill.id})
        .then (resource) ->
          skill.interview_guides[index] = resource

          skill.interview_guides = skill.interview_guides.sortBy (item)-> item.num

        .catch (errorResponse) ->
          # Revert drop if not valid
          skill.interview_guides.pop()
          console.log "errorResponse = ", errorResponse
          console.log "validateErrors = ", errorResponse.data.errors.join(', ')

  $scope.removeInterviewGuide = (guide, skill)->
    JobInterviewGuide.remove(guide.id)
    .then (resource)->
      skill.interview_guides.remove (item)->
        item.id == guide.id
    .catch (errorResponse)->
      console.log "errorResponse = ", errorResponse

  $scope.getJob = ()->
    if $scope.resource?
      $scope.job = $scope.resource
      $scope.previous_interview_guides_count = $scope.job.interview_guides_count
      $scope.buildInterviewGuides()
    else
      Job.get($scope.job.id).then (resource) ->
        $scope.job = resource
        $scope.previous_interview_guides_count = $scope.job.interview_guides_count
        $scope.buildInterviewGuides()

  $scope.updateInterviewGuidesCounts =()->
    if $scope.previous_interview_guides_count != $scope.job.interview_guides_count
      Job.update(id: $scope.job.id, interview_guides_count: $scope.job.interview_guides_count)
      .then (resource)->
        # $scope.job = resource
        if $scope.previous_interview_guides_count > $scope.job.interview_guides_count
          $scope.clearOldInterviewGuides()
        $scope.previous_interview_guides_count = $scope.job.interview_guides_count
        $scope.buildInterviewGuides()

  $scope.getSkills = ()->
    if $scope.resource?.job_skills?
      $scope.skills = $scope.resource.job_skills
      $scope.isSkillLoaded = true
    else
      JobSkill.all($scope.job.id)
      .then (resources) ->
        $scope.skills = resources
        angular.forEach $scope.skills, (skill, key)-> 
          skill.interview_guides = [] unless skill.interview_guides?
        # $scope.getJobInterviewGuides()
        $scope.isSkillLoaded = true
      .catch (errorResponse) ->
        console.log "errorResponse = " + errorResponse
        []

  $scope.getJobInterviewGuides = () ->
    JobInterviewGuide.all($scope.job.id)
    .then (resources) ->
      angular.forEach $scope.skills, (skill, key)->
        skill.interview_guides = resources.findAll (guide)-> guide.job_skill_id == skill.id
        skill.interview_guides = skill.interview_guides.sortBy (item)-> item.num

    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse
      []

  $scope.clearOldInterviewGuides = ()->
    angular.forEach $scope.skills, (skill, key)->
      angular.forEach skill.interview_guides, (guide, key)->
        if guide.num > $scope.job.interview_guides_count
          $scope.removeInterviewGuide(guide, skill)

  $scope.initNumberOfInterviewGuides = ()->
    $scope.interview_guides.length

  $scope.getJob()
  $scope.getSkills()

  # ####### HELPER METHODS
  $scope.generateInterviewGuideTitle = (num)->
    "Interviewer #{String.fromCharCode(64 + num)}"

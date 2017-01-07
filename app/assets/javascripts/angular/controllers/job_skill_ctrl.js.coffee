app.controller "JobSkillCtrl", ($scope, $stateParams, $state, $window, JobSkill) ->
  console.log "-- JobSkillCtrl, $stateParams=" + $stateParams
  # console.log $scope.resource

  $scope.job_skill_id = Number($stateParams.id) # job skill id

  $scope.removeSkill = () ->
    deleteUser = $window.confirm('Are you sure you want to delete job skill?')
    if deleteUser
      JobSkill.delete($scope.resource.id, $scope.job_skill_id)
      $scope.resource.job_skills.remove((item) -> item.id == $scope.job_skill_id)
      $state.go("app.setup")

  $scope.show_items_textarea = false # show/hide specification items textarea
  $scope.items_text = "" # specification textarea
  $scope.items = [] # specification items
  $scope.new_item = "" # new item text
  $scope.line_items = [] # textarea split to items

  if $scope.account.job_skill_questions_enabled
    $scope.enable_question = true # enable question in account level
  $scope.enable_question = true

# Skill Trait Controller of JobSkillCtrl
app.controller "JobSkillTraitCtrl", ["$scope", "$stateParams", "$location", "Account", "JobSkill", "JobSkillTrait", \
                                      ($scope, $stateParams, $location, Account, JobSkill, JobSkillTrait) -> 

  $scope.add_item_label = "" # label for Add button
  $scope.add_item_label_plural = "" # plural label for bulks
  $scope.add_sub_label = "Trait"
  $scope.skill_name = "" # Skill name
  $scope.can_add_sub_items = $scope.account.job_skill_sub_traits_enabled

  $scope.has_relation_with_interview_guide = false

  $scope.getItems = () ->
    skill = $scope.resource.job_skills.find((item) -> item.id is $scope.job_skill_id)
    $scope.items = skill.job_skill_traits || []
    $scope.skill_name = skill.name
    $scope.add_item_label = skill.name
    $scope.add_item_label_plural = skill.name
    $scope.show_items_textarea = $scope.items.length == 0

  if $scope.resource?
    $scope.getItems()

  $scope.enableSubTraits = () ->
    $scope.account.job_skill_sub_traits_enabled = !$scope.account.job_skill_sub_traits_enabled
    $scope.can_add_sub_items = $scope.account.job_skill_sub_traits_enabled
    # Account.update($scope.account)

  $scope.saveBulkToItems = () ->       
    $scope.show_items_textarea = false;

    # split traits textarea to array and compact out blank lines
    $scope.line_items = $scope.items_text.split("\n").compact(true)

    # line_items.each (line_item) ->  
    #  $scope.createItem(line_item.replace("\u2022", "").trim())

    $scope.createTextlinesToItems(0, $scope.line_items.length) if $scope.line_items.length > 0

  $scope.createTextlinesToItems = (index, total) ->
    JobSkillTrait.create($scope.job_skill_id, $scope.line_items[index].replace("\u2022", "").trim()) \
    .then (resources) ->
      $scope.items.push
        id: resources.id
        description: resources.description
        sub_items: []
      if ++index < total
        $scope.createTextlinesToItems(index, total)
    .catch (errorResponse) ->
      console.log  "errorResponse = " + errorResponse

  $scope.showItemsTextArea = () ->
    $scope.items_text = ""
    $scope.show_items_textarea = true

  # save new specification item
  $scope.createItem = (data) ->    
    $scope.new_item = ""
    if data
      JobSkillTrait.create($scope.job_skill_id, data) \
      .then (resources) ->
        $scope.items.push
          id: resources.id
          description: resources.description
          sub_items: []
      .catch (errorResponse) ->
        console.log  "errorResponse = " + errorResponse

  # update specification item
  $scope.updateItem = (index, data, id) ->
    JobSkillTrait.update(id, $scope.job_skill_id, data)

  # remove specification item
  $scope.deleteItem = (index, id) ->
    $scope.items.splice index, 1
    JobSkillTrait.delete(id, $scope.job_skill_id)

  # create sub item
  $scope.createSubItem = (index, item_id, data) ->
    clone_items = $scope.items[index].sub_items.slice(0)
    clone_items.push data
    $scope.new_item = ""
    JobSkillTrait.updateSubItem(item_id, $scope.job_skill_id, clone_items) \
    .then (resources) ->
      $scope.items[index].sub_items = resources.sub_items
    .catch (errorResponse) ->
      console.log  "errorResponse = " + errorResponse

  $scope.updateSubItem = (index, sub_index, item_id, data) ->
    clone_items = $scope.items[index].sub_items.slice(0)
    clone_items[sub_index] = data
    JobSkillTrait.updateSubItem(item_id, $scope.job_skill_id, clone_items) \
    .then (resources) ->
      $scope.items[index].sub_items = resources.sub_items
    .catch (errorResponse) ->
      console.log  "errorResponse = " + errorResponse

  # delete sub item
  $scope.deleteSubItem = (index, sub_index, item_id) ->
    $scope.items[index].sub_items.splice(sub_index, 1)
    JobSkillTrait.updateSubItem(item_id, $scope.job_skill_id, $scope.items[index].sub_items)
]


# Skill Question Controller of JobSkillCtrl
app.controller "JobSkillQuestionCtrl", ["$scope", "$stateParams", "$location", "JobSkill", "JobSkillQuestion", \
                                      ($scope, $stateParams, $location, JobSkill, JobSkillQuestion) ->                                      
  
  $scope.add_item_label = "Question" # label for Add button
  $scope.add_item_label_plural = "Questions" # plural label for bulks
  $scope.can_add_sub_items = false # if need to add sub items, set to true  
  if $scope.account.job_skill_questions_numbered
    $scope.items_numbered = true # items will be numbered

  $scope.getSkill = ->
    $scope.skill = $scope.resource.job_skills.find((item) -> item.id is $scope.job_skill_id)
    
  $scope.has_relation_with_interview_guide = true
  $scope.getInterviewGuides = () ->
    $scope.interview_guides = $scope.skill.interview_guides

  $scope.getItems = () ->
    $scope.items = $scope.resource.job_skills.find((item) -> item.id is $scope.job_skill_id).job_skill_questions || []
    $scope.show_items_textarea = $scope.items.length == 0

  if $scope.resource?
    $scope.getSkill()
    $scope.getItems()
    $scope.getInterviewGuides()

  $scope.saveBulkToItems = () ->       
    $scope.show_items_textarea = false;

    # split question textarea to array and compact out blank lines
    $scope.line_items = $scope.items_text.split("\n").compact(true)

    $scope.createTextlinesToItems(0, $scope.line_items.length) if $scope.line_items.length > 0

  $scope.createTextlinesToItems = (index, total) ->
    JobSkillQuestion.create($scope.job_skill_id, $scope.line_items[index].replace("\u2022", "").trim()) \
    .then (resources) ->
      $scope.items.push
        id: resources.id
        description: resources.description
      if ++index < total
        $scope.createTextlinesToItems(index, total)
    .catch (errorResponse) ->
      console.log  "errorResponse = " + errorResponse

  $scope.showItemsTextArea = () ->
    $scope.items_text = ""
    $scope.show_items_textarea = true

  # save new specification item
  $scope.createItem = (data) ->    
    $scope.new_item = ""
    if data
      JobSkillQuestion.create($scope.job_skill_id, data) \
      .then (resources) ->
        $scope.items.push
          id: resources.id
          description: resources.description
      .catch (errorResponse) ->
        console.log  "errorResponse = " + errorResponse

  # assign interview guide
  $scope.assignInterviewGuide = (item) ->
    JobSkillQuestion.update(item.id, $scope.job_skill_id, {interview_guide_id: item.interview_guide_id})

  # update specification item
  $scope.updateItem = (index, data, id) ->
    JobSkillQuestion.update(id, $scope.job_skill_id, data)

  # remove specification item
  $scope.deleteItem = (index, id) ->
    $scope.items.splice index, 1
    JobSkillQuestion.delete(id, $scope.job_skill_id)
]

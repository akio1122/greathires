app.controller "JobSpecificationCtrl", ["$scope", "$stateParams", "$location", "JobSpecification", "JobSpecificationItem", "JobSpecificationQuestion", \
                                      ($scope, $stateParams, $location, JobSpecification, JobSpecificationItem, JobSpecificationQuestion) ->
  console.log "-- JobSpecificationCtrl, $stateParams id=" + $stateParams.id
  console.log $scope.resource

  $scope.job_specification_id = Number($stateParams.id) # job specification id

  $scope.show_items_textarea = false # show/hide specification items textarea
  $scope.items_text = "" # specification textarea
  $scope.items = [] # specification items
  $scope.new_item = "" # new item text
  $scope.line_items = [] # textarea split to items

  if $scope.account.job_spec_questions_enabled
    $scope.enable_question = true # enable question in account level
]

# Sub Item Controller of JobSpecificationCtrl
app.controller "JobSpecificationItemCtrl", ["$scope", "$stateParams", "$location", "JobSpecification", "JobSpecificationItem", \
                                      ($scope, $stateParams, $location, JobSpecification, JobSpecificationItem) -> 
  
  $scope.add_item_label = "" # label for Add button
  $scope.add_item_label_plural = "" # plural label for bulks
  $scope.add_sub_label = "Bullet"
  $scope.items_numbered = false # items will be numbered
  $scope.specficiation_name = "" # Specification name

  # if need to add sub items, set to true
  $scope.can_add_sub_items = $scope.account.job_spec_text_field_allows_sub_bullets

  $scope.has_relation_with_interview_guide = false

  $scope.getItems = () ->
    specification = $scope.resource.specifications.find((item) -> item.id is $scope.job_specification_id)
    $scope.items = specification.job_specification_items || []
    $scope.specficiation_name = specification.name
    $scope.add_item_label = specification.name
    $scope.add_item_label_plural = specification.name
    $scope.show_items_textarea = $scope.items.length == 0    

  if $scope.resource?
    $scope.getItems()

  $scope.saveBulkToItems = () ->       
    $scope.show_items_textarea = false;

    # split specifications textarea to array and compact out blank lines
    $scope.line_items = $scope.items_text.split("\n").compact(true)

    # line_items.each (line_item) ->  
    #  $scope.createItem(line_item.replace("\u2022", "").trim())

    $scope.createTextlinesToItems(0, $scope.line_items.length) if $scope.line_items.length > 0

  $scope.createTextlinesToItems = (index, total) ->
    JobSpecificationItem.create($scope.job_specification_id, $scope.line_items[index].replace("\u2022", "").trim()) \
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
      JobSpecificationItem.create($scope.job_specification_id, data) \
      .then (resources) ->
        $scope.items.push
          id: resources.id
          description: resources.description
          sub_items: []
      .catch (errorResponse) ->
        console.log  "errorResponse = " + errorResponse

  # update specification item
  $scope.updateItem = (index, data, id) ->
    JobSpecificationItem.update(id, $scope.job_specification_id, data)

  # remove specification item
  $scope.deleteItem = (index, id) ->
    $scope.items.splice index, 1
    JobSpecificationItem.delete(id, $scope.job_specification_id)

  # create sub item
  $scope.createSubItem = (index, item_id, data) ->
    clone_items = $scope.items[index].sub_items.slice(0)
    clone_items.push data
    $scope.new_item = ""
    JobSpecificationItem.updateSubItem(item_id, $scope.job_specification_id, clone_items) \
    .then (resources) ->
      $scope.items[index].sub_items = resources.sub_items
    .catch (errorResponse) ->
      console.log  "errorResponse = " + errorResponse

  $scope.updateSubItem = (index, sub_index, item_id, data) ->
    clone_items = $scope.items[index].sub_items.slice(0)
    clone_items[sub_index] = data
    JobSpecificationItem.updateSubItem(item_id, $scope.job_specification_id, clone_items) \
    .then (resources) ->
      $scope.items[index].sub_items = resources.sub_items
    .catch (errorResponse) ->
      console.log  "errorResponse = " + errorResponse

  # delete sub item
  $scope.deleteSubItem = (index, sub_index, item_id) ->
    $scope.items[index].sub_items.splice(sub_index, 1)
    JobSpecificationItem.updateSubItem(item_id, $scope.job_specification_id, $scope.items[index].sub_items)
]


# Sub Question Controller of JobSpecificationCtrl
app.controller "JobSpecificationQuestionCtrl", ["$scope", "$stateParams", "$location", "JobSpecification", "JobSpecificationQuestion", \
                                      ($scope, $stateParams, $location, JobSpecification, JobSpecificationQuestion) ->                                      
  
  $scope.add_item_label = "Question" # label for Add button
  $scope.add_item_label_plural = "Questions" # plural label for bulks
  $scope.can_add_sub_items = false # if need to add sub items, set to true
  if $scope.account.job_spec_questions_numbered
    $scope.items_numbered = true # items will be numbered

  $scope.has_relation_with_interview_guide = false

  $scope.getItems = () ->
    $scope.items = $scope.resource.specifications.find((item) -> item.id is $scope.job_specification_id).job_specification_questions || []
    $scope.show_items_textarea = $scope.items.length == 0

  if $scope.resource?
    $scope.getItems()

  $scope.saveBulkToItems = () ->       
    $scope.show_items_textarea = false;

    # split specifications textarea to array and compact out blank lines
    $scope.line_items = $scope.items_text.split("\n").compact(true)

    $scope.createTextlinesToItems(0, $scope.line_items.length) if $scope.line_items.length > 0

  $scope.createTextlinesToItems = (index, total) ->
    JobSpecificationQuestion.create($scope.job_specification_id, $scope.line_items[index].replace("\u2022", "").trim()) \
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
      JobSpecificationQuestion.create($scope.job_specification_id, data) \
      .then (resources) ->
        $scope.items.push
          id: resources.id
          description: resources.description
      .catch (errorResponse) ->
        console.log  "errorResponse = " + errorResponse

  # update specification item
  $scope.updateItem = (index, data, id) ->
    JobSpecificationQuestion.update(id, $scope.job_specification_id, data)

  # remove specification item
  $scope.deleteItem = (index, id) ->
    $scope.items.splice index, 1
    JobSpecificationQuestion.delete(id, $scope.job_specification_id)
]
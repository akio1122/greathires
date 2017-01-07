//= require_self
//= require_tree ../base

# Load appropriate directives
//= require ../directives/textarea_to_items
//= require ../directives/gh_edit_in_place
//= require ../directives/show_validation

# Load templates for JobEditor
//= require_tree ../templates/job_editor

#Load appropriate Services
//= require ../services/account_service
//= require ../services/classification_service
//= require ../services/skill_service
//= require ../services/job_skill_service
//= require ../services/job_skill_trait_service
//= require ../services/job_skill_question_service

//= require ../services/user_service
//= require ../services/linkedin_profile_service
//= require ../services/job_service
//= require ../services/job_classification_service
//= require ../services/job_role_service
//= require ../services/job_skill_service
//= require ../services/job_interview_guide_service
//= require ../services/job_specification_service
//= require ../services/job_specification_item_service
//= require ../services/job_specification_question_service

# Load appropriate Controllers
//= require ../controllers/job_ctrl
//= require ../controllers/job_navigator_ctrl
//= require ../controllers/job_setup_ctrl

//= require ../controllers/job_skill_ctrl
//= require ../controllers/job_interview_guides_ctrl
//= require ../controllers/user_selector_ctrl
//= require ../controllers/hiring_team_ctrl
//= require ../controllers/job_specification_ctrl
//= require ../controllers/job_add_skill_modal_ctrl
//= require ../controllers/job_add_template_modal_ctrl


app = angular.module("GreatHires", [ "ui.router", "xeditable", "ui.bootstrap", "restangular", "ngDragDrop", "templates"])

app.config ($stateProvider, $urlRouterProvider) ->
  console.log "in app.config for router"
  $urlRouterProvider.otherwise("setup")

  $stateProvider
  .state('app',
    url: "/"
    #abstract: true
    controller: "JobNavigatorCtrl"
    views: {
      "nav": {
        templateUrl:"job_editor/navigation.html"
        controller: "JobNavigatorCtrl"
      }
      "context": {
        templateUrl:"job_editor/context.html"
        controller: "JobCtrl"
      }
      "content": {
        templateUrl: "job_editor/editor.html"
        controller: "JobCtrl"
      }
    }
  )
  .state('app.setup',
    url: "setup"
    templateUrl: "job_editor/setup.html"
    controller: "JobSetupCtrl"
  )
  .state('app.interview_guides',
    url: "interview-guides"
    templateUrl: "job_editor/interview_guides.html"
    controller: "JobInterviewGuidesCtrl"
  )
  .state('app.hiring_teams',
    url: "hiring-teams"
    templateUrl: "job_editor/hiring_teams.html"
    controller: "HiringTeamCtrl"
  )
  .state('app.skill',
    url: "skill/:id"
    templateUrl: "job_editor/skill.html"
    controller: "JobSkillCtrl"
  )
  .state('app.specification',
    url: "specification/:id"
    templateUrl: "job_editor/specification.html"
    controller: "JobSpecificationCtrl"
  )

app.run ($rootScope, $urlRouter, editableOptions) ->
  editableOptions.theme = 'bs3'
  $rootScope.$on "$locationChangeSuccess", (evt) ->
    evt.preventDefault()
    $urlRouter.sync() if $rootScope.resource? and $rootScope.account?
    return
  return

 app.directive "bsHasError", [ () ->
  restrict: "A"
  link: (scope, element, attrs, ctrl) ->
    input = element.find "input[ng-model]"
    if input?
      scope.$watch () ->
        input.hasClass "ng-invalid"
      , (isInvalid) ->
        element.toggleClass "has-error", isInvalid
]

# Filter the array with first character
app.filter "skillFilter", ->
  (skills, x) ->
    groups = []
    i = 0

    while i < skills.length
      groups.push skills[i]  if skills[i].name.substring(0, 1) is x or x is ""
      i++
    groups



# Since this is a coffeescript file, the statements below put app in the global namespace so other modules can load and attach.
root = exports ? this
root.app = app

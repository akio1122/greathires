//= require_self
//= require_tree ../base

# Load appropriate Templates
//= require_tree ../templates/account_editor

# Load appropriate Directives
//= require ../directives/show_validation
//= require ../directives/textarea_to_items
//= require ../directives/gh_edit_in_place
//= require ../directives/gh_filter

#Load appropriate Services
//= require ../services/account_service
//= require ../services/email_template_service
//= require ../services/invitation_service
//= require ../services/user_service
//= require ../services/user_role_service
//= require ../services/linkedin_profile_service
//= require ../services/role_service
//= require ../services/permission_service
//= require ../services/role_permission_service
//= require ../services/interview_round_service
//= require ../services/interview_type_service
//= require ../services/status_service
//= require ../services/skill_service
//= require ../services/priority_service
//= require ../services/specification_service
//= require ../services/classification_service
//= require ../services/classification_options_service
//= require ../services/rating_scale_option_service

# Load appropriate Controllers
//= require ../controllers/account_ctrl
//= require ../controllers/account_invitations_ctrl
//= require ../controllers/account_invite_user_ctrl
//= require ../controllers/account_manage_users_ctrl
//= require ../controllers/user_selector_ctrl
//= require ../controllers/account_navigator_ctrl
//= require ../controllers/account_job_skill_ctrl
//= require ../controllers/account_job_team_roles_ctrl
//= require ../controllers/account_interview_schedule_ctrl
//= require ../controllers/account_candidate_status_ctrl
//= require ../controllers/account_interview_ctrl
//= require ../controllers/account_job_specifications_ctrl
//= require ../controllers/account_evaluate_ctrl


app = angular.module("GreatHires", [ "ui.router", "xeditable", "ui.bootstrap", "restangular", "ngDragDrop", "templates"])

app.config ($stateProvider, $urlRouterProvider) ->
  console.log "in app.config for router"
  $urlRouterProvider.otherwise("setup")

  $stateProvider
  .state('app',
    url: "/"
    #abstract: true,
    controller: "AccountNavigatorCtrl"
    views: {
      "nav": {
        templateUrl:"account_editor/navigation.html"
        controller: "AccountCtrl"
      }
      "context": {
        templateUrl:"account_editor/context.html"
        controller: "AccountCtrl"
      }
      "content": {
        templateUrl: "account_editor/editor.html"
        controller: "AccountCtrl"
      }
    }
  )
  .state('app.setup',
    url: "setup"
    templateUrl: "account_editor/setup.html"
    controller: "AccountCtrl"
  )
  .state('app.job_specifications',
    url: "job-specifications"
    templateUrl: "account_editor/job_specifications.html"
    controller: "AccountJobSpecificationsCtrl"
  )
  .state('app.permissions',
    url: "permissions"
    templateUrl: "account_editor/permissions.html"
    controller: "AccountJobTeamRolesCtrl"
  )
  .state('app.interview_schedule',
    url: "interview-schedule"
    templateUrl: "account_editor/interview_schedule.html"
    controller: "AccountInterviewScheduleCtrl"
  )
  .state('app.job_skills',
    url: "job-skills"
    templateUrl: "account_editor/job_skills.html"
    controller: "AccountJobSkillCtrl"
  )
  .state('app.prepare',
    url: "prepare"
    templateUrl: "account_editor/prepare.html"
    controller: "AccountCtrl"
  )
  .state('app.interview',
    url: "interview"
    templateUrl: "account_editor/interview.html"
    controller: "AccountInterviewCtrl"
  )
  .state('app.evaluate',
    url: "evaluate"
    templateUrl: "account_editor/evaluate.html"
    controller: "AccountEvaluateCtrl"
  )
  .state('app.canditate_status',
    url: "canditate-status"
    templateUrl: "account_editor/candidate_status.html"
    controller: "AccountCandidateStatusCtrl"
  )
  .state('app.invitations',
    url: "invitations"
    templateUrl: "account_editor/invitations.html"
    controller: "AccountInvitationsCtrl"
  )
  .state('app.invite_user',
    url: "invite_user"
    templateUrl: "account_editor/invite_user.html"
    controller: "AccountInviteUserCtrl"
  )
  .state('app.manage_users',
    url: "manage-users"
    templateUrl: "account_editor/manage_users.html"
    controller: "AccountManageUsersCtrl"
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

app.directive "ngEnter", ->
  (scope, element, attrs) ->
    element.bind "keydown keypress", (event) ->
      if event.which is 13
        scope.$apply ->
          scope.$eval attrs.ngEnter

        event.preventDefault()

app.directive "ngEsc", ->
  (scope, element, attrs) ->
    element.bind "keydown keypress", (event) ->
      if event.which is 27
        scope.$apply ->
          scope.$eval attrs.ngEsc

        event.preventDefault()



# Since this is a coffeescript file, the statements below put app in the global namespace so other modules can load and attach.
root = exports ? this
root.app = app

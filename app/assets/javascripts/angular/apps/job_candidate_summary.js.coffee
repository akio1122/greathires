//= require_self
//= require_tree ../base
//= require ../directives/show_validation
//= require ../directives/phone_mask
//= require ../directives/timezone_select
//= require ../directives/direct_upload

# Load templates for Candidate Summary
//= require_tree ../templates/job_candidate_summary/
//= require_tree ../templates/job_interview/

#Load appropriate Services
//= require ../services/account_service
//= require ../services/candidate_service
//= require ../services/user_service
//= require ../services/linkedin_profile_service
//= require ../services/job_service
//= require ../services/job_candidate_service
//= require ../services/job_interview_service
//= require ../services/interview_round_service
//= require ../services/interview_type_service
//= require ../services/job_interview_guide_service
//= require ../services/note_service
//= require ../services/media_service
//= require ../services/s3_signature_service

# Load appropriate Controllers
//= require ../controllers/job_candidate_summary_ctrl
//= require ../controllers/job_interview_add_modal_ctrl
//= require ../controllers/job_interview_ctrl
//= require ../controllers/job_interview_context_ctrl
//= require ../controllers/user_selector_ctrl
//= require ../controllers/candidate_social_and_attachment_modal_ctrl

# Establish the application
app = angular.module("GreatHires", ["ui.router", "xeditable", "ui.bootstrap", "restangular", "templates"])

# Establish the Routes
app.config ($stateProvider, $urlRouterProvider) ->
  console.log "in config_and_routes for Job Candidate Summary router"
  $urlRouterProvider.otherwise("/")

  $stateProvider
  .state('index',
    url: "/"
    views: {
      "nav": { 
        templateUrl: "job_candidate_summary/navigation.html" 
      }
      "context": { 
        templateUrl: "job_candidate_summary/context.html" 
        controller: "JobCandidateSummaryCtrl"
      }
      "content": {
        templateUrl: "job_candidate_summary/index.html"
        controller: "JobCandidateSummaryCtrl"
      }
    }
  )
  .state('interviews',
    url: "/interviews/:id"
    views: {
      "context": { 
        templateUrl: "job_interview/context.html" 
        controller: "JobInterviewContextCtrl"      }
      "content": {
        templateUrl: "job_interview/index.html"
        controller: "JobInterviewCtrl"
      }
    }
  )


app.run ($rootScope, $urlRouter) ->
  $rootScope.$on "$locationChangeSuccess", (evt) ->
    evt.preventDefault()
    $urlRouter.sync() if $rootScope.resource? and $rootScope.account?


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


# Since this is a coffeescript file, the statements below put app in the global namespace so other modules can load and attach.
root = exports ? this
root.app = app

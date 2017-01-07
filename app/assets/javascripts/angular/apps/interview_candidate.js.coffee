//= require_self
//= require_tree ../base

# Load appropriate directives
//= require ../directives/gh_rating

# Load supporting Angular templates
//= require_tree ../templates/interview/

#Load supporting Angular Services
//= require ../services/job_service
//= require ../services/job_candidate_service
//= require ../services/job_skill_question_service
//= require ../services/job_candidate_rating_service

# Load Angular Controllers
//= require ../controllers/interview_navigator_ctrl
//= require ../controllers/interview_content_ctrl
//= require ../controllers/interview_priorities_ctrl
//= require ../controllers/interview_prepare_ctrl
//= require ../controllers/interview_candidate_ctrl
//= require ../controllers/interview_evaluate_ctrl

# Establish the application
app = angular.module("GreatHires", ["ui.router", "xeditable", "ui.bootstrap", "restangular", "templates"])

# Establish the Routes
app.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise("prepare")

  $stateProvider
  .state('app',
    url: "/"
    controller: "InterviewContentCtrl"
    views: {
      "nav": { 
        templateUrl: "interview/navigation.html"
        controller: "InterviewNavigatorCtrl"
      }
      "content": {
        templateUrl: "interview/content.html"
        controller: "InterviewContentCtrl"
      }
    }
  )
  .state('app.prepare',
    url: "prepare"
    templateUrl: "interview/candidate_prepare.html"
    controller: "InterviewPrepareCtrl"
  )
  .state('app.interview',
    url: "interview"
    templateUrl: "interview/candidate_interview.html"
    controller: "InterviewCandidateCtrl"
  )
  .state('app.evaluate',
    url: "evaluate"
    templateUrl: "interview/candidate_evaluate.html"
    controller: "InterviewEvaluateCtrl"
  )
  .state('app.priorities',
    url: "priorities"
    templateUrl: "interview/candidate_priorities.html"
    controller: "InterviewPrioritiesCtrl"
  )

app.run ($rootScope, $urlRouter) ->
  $rootScope.$on "$locationChangeSuccess", (evt) ->
    evt.preventDefault()
    $urlRouter.sync() if $rootScope.job?

# Since this is a coffeescript file, the statements below put app in the global namespace so other modules can load and attach.
root = exports ? this
root.app = app

//= require_self
//= require_tree ../base

# Load supporting Angular templates
//= require_tree ../templates/interview_lister

# Load supporting Angular Services

# Load Angular Controllers
//= require ../controllers/interviews_ctrl
//= require ../controllers/interviews_lister_ctrl

# Establish the application
app = angular.module("GreatHires", ["ui.router", "xeditable", "ui.bootstrap", "restangular", "templates"])

# Establish the Routes
app.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise("/")

  $stateProvider
  .state('app',
    url: "/"
    views: {
      "nav": { 
        templateUrl: "interview_lister/navigation.html"
        controller: "InterviewsCtrl"
      }
      "view_filter": {
        templateUrl: "interview_lister/view_filter.html"
      }
      "content": {
        templateUrl: "interview_lister/index.html"
        controller: "InterviewsCtrl"
      }
    }
  )
  .state('app.today',
    url: "today"
    templateUrl: "interview_lister/lister.html"
    controller: "InterviewsListerCtrl"
  )
  .state('app.upcoming',
    url: "upcoming"
    templateUrl: "interview_lister/lister.html"
    controller: "InterviewsListerCtrl"
  )
  .state('app.past',
    url: "past"
    templateUrl: "interview_lister/lister.html"
    controller: "InterviewsListerCtrl"
  )
app.run ($rootScope, $urlRouter) ->
  $rootScope.$on "$locationChangeSuccess", (evt) ->
    evt.preventDefault()
    $urlRouter.sync() if $rootScope.preload_resources?
    return
  return

# Since this is a coffeescript file, the statements below put app in the global namespace so other modules can load and attach.
root = exports ? this
root.app = app

//= require_self
//= require_tree ../base

# Load supporting Angular templates
//= require_tree ../templates/job_lister/

#Load supporting Angular Services
//= require ../services/job_service
//= require ../services/job_role_service

# Load Angular Controllers
//= require ../controllers/jobs_ctrl
//= require ../controllers/job_add_modal_ctrl

# Establish the application
app = angular.module("GreatHires", ["ui.router", "xeditable", "ui.bootstrap", "restangular", "templates"])

# Establish the Routes
app.config ($stateProvider, $urlRouterProvider) ->
  console.log "in config_and_routes for JL router"
  #$urlRouterProvider.otherwise("/")

  $stateProvider
  .state('index',
    url: ""
    views: {
      "nav": { 
        templateUrl: "job_lister/navigation.html"
        controller: "JobsCtrl"
      }
      "context": { 
        templateUrl: "job_lister/context.html"
        controller: "JobsCtrl"
      }
      "content": {
        templateUrl: "job_lister/index.html"
        controller: "JobsCtrl"
      }
    }
  )

# Since this is a coffeescript file, the statements below put app in the global namespace so other modules can load and attach.
root = exports ? this
root.app = app

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require modernizr
// Underscore is required mostly for Backbone's usage and it sometimes used in some of the AngularJS code but should be re-factored out of the AngularJS code.
// require underscore-min  # This is now loaded from the cdnjs.com to prevent the need for reloading and compiling, see views/shared/_head
//
// require jquery #loaded via jquery-google-cdn
// require Rails jquery adapter
//= require jquery_ujs
//
// require js-routes to make Rails routes available as callable JS objects.
//= require js-routes
//
// The following two includes are from Diane's responsive CSS implementation
//= require jquery.mCustomScrollbar.concat.min
//
// Include bootstrap Javascript based components which are used in parts of the Rails standard templates
// Bootstrap JS components depend on JQuery which works well with Backbone; but not needed for AngularJS
//= require bootstrap
//
// ./libs folder are small utility scripts that may be used by the application.  These are created by GreatHires teams members as opposed to open source libraries
//        found on the Internet which should go into /vendor folder.
//= require_tree ./libs
//= require jquery.ui.draggable
//= require jquery.ui.droppable
//= require jquery.ui.resizable
//= require jquery.ui.selectable
//= require jquery.ui.sortable
//= require jquery.ui.slider
//= require jquery.maskedinput.min
//= require jquery.autosize.min

// require sugar.min # This is now loaded from the Google CDN to prevent the need for reloading and compiling, see views/shared/_head
// require angular   # This is now loaded from the cdnjs.com to prevent the need for reloading and compiling, see views/shared/_head
// Add all AngularJS libraries below. All are used by all AngularJS apps.
//= require angular-ui-router
//= require xeditable.min
//= require angular-dragdrop
//= require inflection
//= require ui-bootstrap.0.9.0
//= require ui-bootstrap-tpls-0.11.0
//= require restangular.min
//= require angular-rails-templates
//= require_tree ./angular/templates/directives
//= require_tree ./angular/templates/components


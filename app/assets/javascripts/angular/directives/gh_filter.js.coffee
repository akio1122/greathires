app.directive "ghFilter", ->
  restrict: "AE"
  scope:
    items: '=items'
    current_value: '=currentValue'
    is_open: '=isOpen'
    onFilter: '='
  templateUrl: "directives/gh_filter.html"

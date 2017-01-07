app.directive "inputMaskPhone", ->
  require: "ngModel"
  link: (scope, elem, attr, ctrl) ->
    elem.mask "(999) 999-9999"
    elem.on "keyup", ->
      scope.$apply ->
        ctrl.$setViewValue elem.val()
        return
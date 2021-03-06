// Borrowed from: http://stackoverflow.com/questions/14348384/reconcile-angular-js-and-bootstrap-form-validation-styling
app.directive('showValidation', [function() {
        return {
            restrict: "A",
            link: function(scope, element, attrs, ctrl) {

                if (element.get(0).nodeName.toLowerCase() === 'form') {
                    element.find('.form-group').each(function(i, formGroup) {
                        showValidation(angular.element(formGroup));
                    });
                } else {
                    showValidation(element);
                }

                function showValidation(formGroupEl) {
                    var input = formGroupEl.find('input[ng-model],textarea[ng-model]');
                    if (input.length > 0) {
                        scope.$watch(function() {
                            return input.hasClass('ng-invalid');
                        }, function(isInvalid) {
                            formGroupEl.toggleClass('has-error', isInvalid);
                        });
                    }
                }
            }
        };
    }]);
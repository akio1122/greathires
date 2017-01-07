
app.directive('autoSave', function () {
    return {
        restrict: 'A',
        link: function (scope, element, attrs, ctrl) {

            // TODO: support model callbacks
            var save = function () {
                console.log ("in autosave!");
                ctrl.update(element);
                // Restangular.put(attrs.objectStore, scope[attrs.autoSave]);
            };
            element.bind('blur', scope.update(element));
            /*
            // TODO: configurable throttling
            $timeout(function () {
                element.find('input, textarea').bind('blur', save);
            }, 100); */
         }
    };
});


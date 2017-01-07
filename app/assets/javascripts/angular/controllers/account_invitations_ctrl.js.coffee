app.controller "AccountInvitationsCtrl", ["$scope", "$state", "$stateParams", "EmailTemplate", \
                                        ($scope, $stateParams, $state, EmailTemplate) ->
  $scope.invitation_template = 
    kind: "invitation"

  $scope.notification_template = 
    kind: "notification"

  $scope.saveInvitationEmailTemplate = ->
    $scope.invitation_template.account_id = $scope.account.id
    $scope.invitation_template.name = "Invitation email template for #{$scope.account.company_name}"

    if $scope.invitation_template.id?
      EmailTemplate.update($scope.invitation_template)
      .then (resource)->
        console.log(resource)
      .catch (errorResponse)->
        console.log "errorResponse = "
        console.log errorResponse
    else
      EmailTemplate.create($scope.invitation_template)
      .then (resource)->
        $scope.invitation_template.id = resource.id
        console.log(resource)
      .catch (errorResponse)->
        console.log "errorResponse = "
        console.log errorResponse

  $scope.saveNotificationEmailTemplate = ->
    $scope.notification_template.account_id = $scope.account.id
    $scope.notification_template.name = "Notification email template for #{$scope.account.company_name}"

    if $scope.notification_template.id?
      EmailTemplate.update($scope.notification_template)
      .then (resource)->
        $scope.notification_template.id = resource.id
      .catch (errorResponse)->
        console.log "errorResponse = "
        console.log errorResponse
    else
      EmailTemplate.create($scope.notification_template)
      .then (resource)->
        console.log(resource)
      .catch (errorResponse)->
        console.log "errorResponse = "
        console.log errorResponse

  $scope.getEmailTemplate = ->

    # Fetch two email templates(invitation and notification) via one api access
    EmailTemplate.all($scope.account.id)
    .then (resources) ->
      return if resources.length == 0

      # return if invitation template does not exist
      $scope.invitation_template = resources.find( (e)-> e.kind == "invitation" )

      # return if invitation template does not exist
      $scope.notification_template = resources.find( (e)-> e.kind == "invitation" )

      return
    .catch (errorResponse) ->
      console.log "errorResponse = " + errorResponse
      []

  $scope.getEmailTemplate();


]
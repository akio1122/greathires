app.factory "Skill", ["Restangular", (Restangular) ->
  new class Skill
    constructor: ->

    all: (account_id, params) ->
      # returns a promise that is expected to handle the success outcome.
      Restangular.one("accounts", account_id).all("skills").getList(params)
      .catch (errorResponse) ->
        # Should handle everything but validation error types here.  Ideally controlling a Flash message that indicates non validation errors.
        console.log "-- skill, errorResponse=" + JSON.stringify(errorResponse)

    save: (account_id, name) ->      
      newResource =
        account_id: account_id
        name: name
        active: true
      #return a promise to the post, then and catch outcomes to be handled by controller
      return Restangular.one("accounts", account_id).all("skills").post(newResource)

    update: (id, account_id, name, active) ->
      updateResource =
        name: name
        active: active

      restangular = Restangular.one("accounts", account_id).one("skills", id)

      return restangular.patch(updateResource)

    remove: (id) ->
      Restangular.one("skills", id).remove()
  ]


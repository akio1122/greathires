app.factory "UserRole", ["Restangular", (Restangular) ->
  new class UserRole
    constructor: ->

    all: (account_id, params={}) ->
      Restangular.one("accounts", account_id)
        .customGET("user_roles", params)

    get: (id)->
      Restangular.one("user_roles", id).get(with_linkedin: true)

    update: (id, role_id, status) ->
      restangular = Restangular.one("user_roles", id)
      updateResource =
        role_id: role_id
        status: status

      return restangular.patch(updateResource)

    remove: (account_id, id) ->
      Restangular.one("accounts", account_id).one("user_roles", id).remove()
  ]
app.factory "RolePermission", ["Restangular", (Restangular) ->
  new class RolePermission
    constructor: ->

    all: (account_id) ->
      Restangular.one("accounts", account_id).all("role_permissions").getList()

    get: (id)->
      Restangular.one("role_permissions", id).get()

    update: (id, value) ->
      restangular = Restangular.one("role_permissions", id)
      updateResource =
        value: value

      return restangular.patch(updateResource)

    remove: (account_id, id) ->
      Restangular.one("accounts", account_id).one("role_permissions", id).remove()
  ]
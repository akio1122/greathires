app.factory "Role", ["Restangular", (Restangular) ->
  new class Role
    constructor: ->

    all: (account_id) ->
      Restangular.one("accounts", account_id).all("roles").getList()

    get: (id)->
      Restangular.one("roles", id).get()

    create: (account_id, name, template_id) ->
      restangular = Restangular.one("accounts", account_id).all("roles")
      attrs =
        name: name
        template_id: template_id
        account_id: account_id

      return restangular.post(attrs)

    update: (id, name) ->
      restangular = Restangular.one("roles", id)
      updateResource =
        name: name

      return restangular.patch(updateResource)

    remove: (account_id, id) ->
      Restangular.one("accounts", account_id).one("roles", id).remove()
  ]
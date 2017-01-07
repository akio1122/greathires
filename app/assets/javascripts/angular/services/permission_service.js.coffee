app.factory "Permission", ["Restangular", (Restangular) ->
  new class Permission
    constructor: ->

    all: (account_id) ->
      Restangular.one("accounts", account_id).all("permissions").getList()

    get: (id)->
      Restangular.one("permissions", id).get()

  ]
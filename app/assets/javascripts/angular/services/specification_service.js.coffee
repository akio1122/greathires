app.factory "Specification", ["Restangular", (Restangular) ->
  new class Specification
    constructor: ->

    all: (account_id, params) ->
      Restangular.one("accounts", account_id).all("specifications").getList(params)

    create: (account_id, attrs) ->
      restangular = Restangular.one("accounts", account_id).all("specifications")
      restangular.post attrs

    update: (id, account_id, attrs) ->
      restangular = Restangular.one("accounts", account_id).one("specifications", id)

      return restangular.patch(attrs)

    remove: (id) ->
      Restangular.one("specifications", id).remove()
  ]
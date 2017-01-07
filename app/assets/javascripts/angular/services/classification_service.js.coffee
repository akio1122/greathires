app.factory "Classification", ["Restangular", (Restangular) ->
  new class Classification
    constructor: ->

    all: (account_id, params) ->
      Restangular.one("accounts", account_id).all("classifications").getList(params)

    create: (account_id, attrs) ->
      restangular = Restangular.one("accounts", account_id).all("classifications")
      restangular.post attrs

    update: (id, account_id, attrs) ->
      restangular = Restangular.one("accounts", account_id).one("classifications", id)

      return restangular.patch(attrs)

    remove: (id) ->
      Restangular.one("classifications", id).remove()
  ]


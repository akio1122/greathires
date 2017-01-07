app.factory "Proirity", ["Restangular", (Restangular) ->
  new class Proirity
    constructor: ->

    all: (account_id, params) ->
      Restangular.one("accounts", account_id).all("priorities").getList(params)

    create: (account_id, attrs) ->
      interviewTypes = Restangular.one("accounts", account_id).all("priorities")
      interviewTypes.post attrs

    update: (id, account_id, attrs) ->
      restangular = Restangular.one("accounts", account_id).one("priorities", id)

      return restangular.patch(attrs)

    remove: (id) ->
      Restangular.one("priorities", id).remove()
  ]
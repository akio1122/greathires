app.factory "Status", ["Restangular", (Restangular) ->
  new class Status
    constructor: ->

    all: (account_id, params) ->
      Restangular.one("accounts", account_id).all("statuses").getList(params)

    create: (account_id, attrs) ->
      interviewTypes = Restangular.one("accounts", account_id).all("statuses")
      interviewTypes.post attrs

    update: (id, account_id, attrs) ->
      restangular = Restangular.one("accounts", account_id).one("statuses", id)

      return restangular.patch(attrs)

    remove: (id) ->
      Restangular.one("statuses", id).remove()
  ]
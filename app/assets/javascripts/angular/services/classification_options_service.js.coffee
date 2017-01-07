app.factory "ClassificationOption", ["Restangular", (Restangular) ->
  new class ClassificationOption
    constructor: ->

    all: (account_id, params) ->
      Restangular.one("accounts", account_id).all("classification_options").getList(params)

    create: (account_id, attrs) ->
      restangular = Restangular.one("accounts", account_id).all("classification_options")
      restangular.post attrs

    update: (id, account_id, attrs) ->
      restangular = Restangular.one("accounts", account_id).one("classification_options", id)

      return restangular.patch(attrs)

    remove: (id) ->
      Restangular.one("classification_options", id).remove()
  ]
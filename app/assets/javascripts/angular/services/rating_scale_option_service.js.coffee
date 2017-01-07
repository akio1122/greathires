app.factory "RatingScaleOption", ["Restangular", (Restangular) ->
  new class RatingScaleOption
    constructor: ->

    all: (account_id, params) ->
      Restangular.one("accounts", account_id).all("rating_scale_options").getList(params)

    update: (id, account_id, attrs) ->
      restangular = Restangular.one("accounts", account_id).one("rating_scale_options", id)

      restangular.patch(attrs)

  ]
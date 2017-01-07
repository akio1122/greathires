app.factory "Candidate", ["Restangular", (Restangular) ->
  new class Candidate
    constructor: ->

    create: (account_id, attrs) ->     
      restangular = Restangular.one("accounts", account_id).all("candidates")
      return restangular.post(attrs)

    update: (account_id, attrs) ->
      restangular = Restangular.one("accounts", account_id).one("candidates", attrs.id)
      return restangular.patch(attrs)
  ]
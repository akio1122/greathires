app.factory "Account", ["Restangular", (Restangular) ->
  new class Account
    constructor: ->

    get: (id)->
      Restangular.one("accounts", id).get()

    all: () ->
      Restangular.all("accounts").getList()

    create: (attrs) ->
      restangular = Restangular.all("accounts")
      #return a promise to the post to be handled by controller
      restangular.post(attrs)

    update: (resource) ->
      if resource.patch?
        return resource.patch()
      else Restangular.one("accounts", resource.id).patch(resource)

]
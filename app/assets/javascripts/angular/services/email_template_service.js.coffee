app.factory "EmailTemplate", ["Restangular", (Restangular) ->
  new class Account
    constructor: ->

    get: (id)->
      Restangular.one("email_templates", id).get()

    all: (account_id) ->
      Restangular.all("email_templates").getList({account_id: account_id})

    create: (attrs) ->
      restangular = Restangular.all("email_templates")
      #return a promise to the post to be handled by controller
      restangular.post(attrs)

    update: (resource) ->
      if resource.patch?
        return resource.patch()
      else Restangular.one("email_templates", resource.id).patch(resource)

]
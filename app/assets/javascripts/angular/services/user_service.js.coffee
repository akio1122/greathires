app.factory "User", ["Restangular", (Restangular) ->
  new class User
    constructor: ->

    all: (account_id, params) ->
      Restangular.one("accounts", account_id).all("users").getList(params)

    get: (id)->
      Restangular.one("users", id).get(with_linkedin: true)

    save: (attrs) ->
      if attrs.id?
        @update attrs.id, attrs.first, attrs.last, attrs.email, attrs.linkedin_id
      else
        @create attrs.first, attrs.last, attrs.email, attrs.linkedin_id

    create: (first, last, email, linkedin_id) ->
      restangular = Restangular.all("users")
      newResource =
        first: first
        last:  last
        email: email
        linkedin_id:   linkedin_id
      return restangular.post(newResource)

    update: (id, first, last, email, linkedin_id) ->
      restangular = Restangular.one("users", id)
      updateResource =
        first: first
        last:  last
        email: email
        linkedin_id:   linkedin_id
      return restangular.patch(updateResource)
  ]
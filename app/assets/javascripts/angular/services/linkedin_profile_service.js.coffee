app.factory "LinkedInProfile", ["Restangular", (Restangular) ->
  new class LinkedInProfile
    constructor: ->

    all: (account_id, first, last) ->
      params =
        first: first
        last: last
        account_id: account_id

      Restangular.all("linkedin").getList(params)
    
    get: (linkedin_id) ->
      Restangular.one("linkedin", linkedin_id).get()

  ]

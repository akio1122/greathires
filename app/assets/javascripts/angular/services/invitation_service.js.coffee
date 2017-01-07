app.factory "Invitation", ["Restangular", (Restangular) ->
  new class Account
    constructor: ->

    invite: (account_id, users) ->
      Restangular.all("invitations").customGET("invite", {account_id: account_id, users: users})

]
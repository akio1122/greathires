app.factory "InterviewRound", ["Restangular", (Restangular) ->
  new class InterviewRound
    constructor: ->

    all: (account_id, params={}) ->
      Restangular.one("accounts", account_id).all("interview_rounds").getList(params)

    create: (account_id, attrs) ->
      interviewRounds = Restangular.one("accounts", account_id).all("interview_rounds")
      interviewRounds.post attrs

    update: (id, account_id, attrs) ->
      restangular = Restangular.one("accounts", account_id).one("interview_rounds", id)

      return restangular.patch(attrs)

    remove: (id) ->
      Restangular.one("interview_rounds", id).remove()
  ]
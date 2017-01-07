app.factory "InterviewType", ["Restangular", (Restangular) ->
  new class InterviewType
    constructor: ->

    all: (account_id, params) ->
      Restangular.one("accounts", account_id).all("interview_types").getList(params)

    create: (account_id, attrs) ->
      interviewTypes = Restangular.one("accounts", account_id).all("interview_types")
      interviewTypes.post attrs

    update: (id, account_id, attrs) ->
      restangular = Restangular.one("accounts", account_id).one("interview_types", id)

      return restangular.patch(attrs)

    remove: (id) ->
      Restangular.one("interview_types", id).remove()
  ]
app.factory "Note", ["Restangular", (Restangular) ->
  new class Note
    constructor: ->

    all: (job_candidate_id) ->
      Restangular.one("job_candidates", job_candidate_id).all("notes").getList()

    get: (id) ->
      Restangular.one("notes", id).get()

    create: (attrs) ->     
      return restangular = Restangular.all("notes").post(attrs)
]
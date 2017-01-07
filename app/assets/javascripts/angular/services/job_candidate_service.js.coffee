app.factory "JobCandidate", ["Restangular", (Restangular) ->
  new class JobCandidate
    constructor: ->

    all: (job_id) ->
      Restangular.one("jobs", job_id).all("job_candidates").getList()

    get: (id) ->
      Restangular.one("job_candidates", id).get()
      
    create: (job_id, candidate_id) ->     
      restangular = Restangular.one("jobs", job_id).all("job_candidates")
      attrs =
        job_id: job_id
        candidate_id: candidate_id
      return restangular.post(attrs)

    update: (job_id, id, resource) ->     
      restangular = Restangular.one("jobs", job_id).one("job_candidates", id)
      return restangular.patch(resource)

    delete: (job_id, id) ->
      Restangular.one('jobs', job_id).one('job_candidates', id).remove()
  ]

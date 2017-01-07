app.factory "JobInterview", ["Restangular", (Restangular) ->
  new class JobInterview
    constructor: ->

    all: (candidate_id) ->
      Restangular.all("job_interviews").getList({job_candidate_id: candidate_id})

    create: (job_id, attrs) ->
      jobInterview = Restangular.one("jobs", job_id).all("job_interviews")
      jobInterview.post attrs

    update: (resource) ->
      Restangular.one("job_interviews", resource.id).patch(resource)

    remove: (id) ->
      Restangular.one("job_interviews", id).remove()
  ]
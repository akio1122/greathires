app.factory "JobSpecification", ["Restangular", (Restangular) ->
  new class JobSpecification
    constructor: ->

    all: (job_id) ->
      Restangular.one("jobs", job_id).all("job_specifications").getList()
  ]

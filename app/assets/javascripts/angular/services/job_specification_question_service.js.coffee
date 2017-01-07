app.factory "JobSpecificationQuestion", ["Restangular", (Restangular) ->
  new class JobSpecificationQuestion
    constructor: ->

    all: (job_specification_id) ->
      Restangular.one("job_specifications", job_specification_id).all("job_specification_questions").getList()

    create: (job_specification_id, description) ->
      restangular = Restangular.one("job_specifications", job_specification_id).all("job_specification_questions")
      newResource =
        job_specification_id: job_specification_id
        description: description
      return restangular.post(newResource)

    update: (id, job_specification_id, description) ->
      restangular = Restangular.one("job_specifications", job_specification_id).one("job_specification_questions", id)
      updateResource =
        description: description
      return restangular.patch(updateResource)

    delete: (id, job_specification_id) ->
      Restangular.one('job_specifications', job_specification_id).one('job_specification_questions', id).remove()
  ]

app.factory "JobSpecificationItem", ["Restangular", (Restangular) ->
  new class JobSpecificationItem
    constructor: ->

    all: (job_specification_id) ->
      Restangular.one("job_specifications", job_specification_id).all("job_specification_items").getList()

    create: (job_specification_id, description) ->
      restangular = Restangular.one("job_specifications", job_specification_id).all("job_specification_items")
      newResource =
        job_specification_id: job_specification_id
        description: description
      return restangular.post(newResource)

    update: (id, job_specification_id, description) ->
      restangular = Restangular.one("job_specifications", job_specification_id).one("job_specification_items", id)
      updateResource =
        description: description
      return restangular.patch(updateResource)

    updateSubItem: (id, job_specification_id, sub_items) ->
      restangular = Restangular.one("job_specifications", job_specification_id).one("job_specification_items", id)
      updateResource =
        sub_items: sub_items
      return restangular.patch(updateResource)

    delete: (id, job_specification_id) ->
      Restangular.one('job_specifications', job_specification_id).one('job_specification_items', id).remove()
  ]

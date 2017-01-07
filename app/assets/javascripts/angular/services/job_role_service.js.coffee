app.factory "JobRole", ["Restangular", (Restangular) ->
  new class JobRole
    constructor: ->

    all: (job_id) ->
      Restangular.one("jobs", job_id).all("job_roles").getList()

    new: (attrs) ->
      item = Restangular.one("jobs", attrs.job_id).one("job_roles")
      item[key] = value for key, value of attrs
      item

    create: (job_id, attrs) ->
      jobRoles = Restangular.one("jobs", job_id).all("job_roles")
      jobRoles.post attrs

    remove: (id) ->
      Restangular.one("job_roles", id).remove()
  ]
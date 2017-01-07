app.factory "Job", ["Restangular", (Restangular) ->
  new class Job
    constructor: ->

    get: (id)->
      Restangular.one("jobs", id).get()

    all: (account_id) ->
      Restangular.one("accounts", account_id).all("jobs").getList()

    create: (account_id, attrs, suggestion_id) ->
      restangular = Restangular.one("accounts", account_id).all("jobs")
      restangular.post(attrs, {job_id: suggestion_id})

    update: (resource) ->
      if resource.patch?
        return resource.patch()
      else Restangular.one("jobs", resource.id).patch(resource)

    getExistingJobTemplate: (account_id) ->
      Restangular.one("accounts", account_id).getList("jobs", {templates: true})

    getPastJobs: (account_id) ->
      Restangular.one("accounts", account_id).getList("jobs", {past: true})

    checkPermission: (action, roles, role_permissions) ->
      allow = false
      roles.each (role) ->
        permission = role_permissions.find((item) -> item.role_id is role.role_id && item.permission_action is action)
        if permission?
          allow = true if permission.value
      allow
]
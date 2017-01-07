app.factory "JobSkill", ["Restangular", (Restangular) ->
  new class JobSkill
    constructor: ->

    all: (job_id) ->
      Restangular.one("jobs", job_id).all("job_skills").getList()

    save: (job_id, skill_id) ->
      restangular = Restangular.one("jobs", job_id).all("job_skills")
      newResource =
        job_id: job_id
        skill_id: skill_id
      #return a promise to the post to be handled by controller
      return restangular.post(newResource)

    delete: (job_id, job_skill_id) ->
      Restangular.one("jobs", job_id).one("job_skills", job_skill_id).remove()
  ]

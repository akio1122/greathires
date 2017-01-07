app.factory "JobSkillQuestion", ["Restangular", (Restangular) ->
  new class JobSkillQuestion
    constructor: ->

    all: (job_skill_id) ->
      Restangular.one("job_skills", job_skill_id).all("job_skill_questions").getList()

    create: (job_skill_id, description) ->
      restangular = Restangular.one("job_skills", job_skill_id).all("job_skill_questions")
      newResource =
        job_skill_id: job_skill_id
        description: description
      return restangular.post(newResource)

    update: (id, job_skill_id, data) ->
      restangular = Restangular.one("job_skills", job_skill_id).one("job_skill_questions", id)
      updateResource = if Object.isObject(data) then data else {description: data}

      return restangular.patch(updateResource)

    delete: (id, job_skill_id) ->
      Restangular.one('job_skills', job_skill_id).one('job_skill_questions', id).remove()
  ]

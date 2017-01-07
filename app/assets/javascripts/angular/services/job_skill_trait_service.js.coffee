app.factory "JobSkillTrait", ["Restangular", (Restangular) ->
  new class JobSkillTrait
    constructor: ->

    all: (job_skill_id) ->
      Restangular.one("job_skills", job_skill_id).all("job_skill_traits").getList()

    create: (job_skill_id, description) ->
      restangular = Restangular.one("job_skills", job_skill_id).all("job_skill_traits")
      newResource =
        job_skill_id: job_skill_id
        description: description
      return restangular.post(newResource)

    update: (id, job_skill_id, description) ->
      restangular = Restangular.one("job_skills", job_skill_id).one("job_skill_traits", id)
      updateResource =
        description: description
      return restangular.patch(updateResource)

    updateSubItem: (id, job_skill_id, sub_items) ->
      restangular = Restangular.one("job_skills", job_skill_id).one("job_skill_traits", id)
      updateResource =
        sub_items: sub_items
      return restangular.patch(updateResource)

    delete: (id, job_skill_id) ->
      Restangular.one('job_skills', job_skill_id).one('job_skill_traits', id).remove()
  ]

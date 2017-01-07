app.factory "JobInterviewGuide", ["Restangular", (Restangular) ->
  new class JobInterviewGuide
    constructor: ->

    all: (job_id) ->
      Restangular.one("jobs", job_id).all("job_interview_guides").getList()

    new: (attrs) ->
      item = Restangular.one("jobs", attrs.job_id).one("job_interview_guides")
      item[key] = value for key, value of attrs
      item

    create: (job_id, job_skill_id, attrs) ->
      attrs.job_id = job_id
      attrs.job_skill_id = job_skill_id
      Restangular.one("jobs", job_id).post("job_interview_guides", attrs)
      # Restangular.service('job_interview_guides').post(attrs)

    remove: (id) ->
      Restangular.one("job_interview_guides", id).remove()
  ]
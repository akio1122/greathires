app.factory "JobCandidateRating", ["Restangular", (Restangular) ->
  new class JobCandidateRating
    constructor: ->

    all: (job_id) ->
      Restangular.one("jobs", job_id).all("job_candidates").getList()

    create: (attrs) ->     
      restangular = Restangular.all("job_candidate_ratings")
      #attrs =
      #  job_candidate_id: 21
      #  job_interview_id: 21
      #  ratable_type: "job_specification_question"
      #  ratable_id: 1
      #  rating_scale_option_id: 51
      #  rating: 1
      #  comment: "Test Comment 333"
      return restangular.post(attrs)
  ]
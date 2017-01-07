
app.factory "JobClassification", ["Restangular", (Restangular) ->
  new class JobClassification
    constructor: ->

    all: (id) ->
      Restangular.one("jobs", id).all("job_classifications").getList()

    save: (job_id, classification_id, option_id) ->    	
    	jobClassifications = Restangular.one("jobs", job_id).all("job_classifications")
    	newJobClassification = 
    		job_id: job_id
    		classification_id: classification_id
    		classification_option_id : option_id

    	jobClassifications.post newJobClassification
      
  ]


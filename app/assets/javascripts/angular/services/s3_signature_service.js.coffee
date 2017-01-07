app.factory 'S3Signature', ['Restangular', (Restangular) ->

  new class S3Signature

    create: (mediable_type, mediable_id, attrs) ->    
      Restangular.service('s3_signature', Restangular.one(mediable_type, mediable_id))
]
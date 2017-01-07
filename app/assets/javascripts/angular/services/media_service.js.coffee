app.factory 'Media', ['Restangular', (Restangular) ->

  new class Media

    create: (mediable_type, mediable_id, attrs) ->     
      Restangular.service('media', Restangular.one(mediable_type, mediable_id)).post(attrs)
    
    destroy: (mediable_type, mediable_id, id) ->
      Restangular.service('media', id, Restangular.one(mediable_type, mediable_id)).delete()
]
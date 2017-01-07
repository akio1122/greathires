app.config ["RestangularProvider", (RestangularProvider) ->
  RestangularProvider.setBaseUrl("/api/v1")
  RestangularProvider.setRequestInterceptor( (elem, operation, what) ->
    if (operation == 'post' || operation == 'put' || operation == 'patch')
      wrapper = {}
      console.log "-- what = " + what
      wrapper[what.singularize()] = elem
      delete elem.createdAt;
      return wrapper
    # taken from: http://stackoverflow.com/questions/18123962/how-to-put-only-some-fields-with-restangular/18168610#18168610

  )
]

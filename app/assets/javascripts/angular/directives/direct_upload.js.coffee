#div direct-upload-button="" mediable_type="job_candidates" 
# mediable_id="123" media_type="resume" media_type="resume" account-id="456"
# mime-types="pdf,png" button-legend="Add Attachment"

app.directive "directUpload", ['Restangular', (Restangular)->
  restrict: "AE"
  scope:
    mediableType: '@'
    mediableId: '@'
    mediaType: '@'
    buttonLegend: '@'
    mimeTypes: '@'
    accountId: '='
  transclude: false
  templateUrl: "directives/direct_upload.html"
  link: (scope, element, attrs, ngModel) ->
    $('#file_upload').fileupload
      forceIframeTransport: true
      autoUpload: true
      add: (event, data) ->
        mediable = Restangular.one(scope.mediableType, scope.mediableId)
        mediable.customPOST({account_id: scope.accountId, filename: data.files[0].name, media_type: scope.mediaType},'s3_signature')
        .then (retdata) ->
          $('#file_upload').find('input[name=key]').val(retdata.key)
          $('#file_upload').find('input[name=policy]').val(retdata.policy)
          $('#file_upload').find('input[name=signature]').val(retdata.signature)
          data.submit()
        .catch (errorResponse)->
          console.log "Error Response of Direct Upload: " + errorResponse

      send: (e, data) ->
        #show a loading spinner because now the form will be submitted to amazon, 
        #and the file will be directly uploaded there, via an iframe in the background. 
        $('#loading').show()
      
      fail: (e, data) ->
        console.log('fail')
        console.log(data)
        $('#loading').hide();

      done: (event, data) ->
        mediable = Restangular.one(scope.mediableType, scope.mediableId)
        mediable.customPOST({
            file_path: $('#file_upload').find('input[name=key]').val(), 
            media_type: scope.mediaType,
            mime_type: data.files[0].type,
            file_size: data.files[0].size
        }, 'media')
        #hide the loading spinner that we turned on earlier.
        $('#loading').hide();
]
    

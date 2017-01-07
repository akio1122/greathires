app.directive "timezoneSelect", ($parse)->
  restrict: "AE"
  require: "?ngModel"
  templateUrl: "directives/timezone_select.html"
  scope: false
  transclude: false
    #ngModel: '='
    #ngValue: '='
  replace: true
  link: (scope, element, attrs, ngModel) ->
    scope.timezone_list = [
      {offset:"-1200", name: "(GMT -12:00) Eniwetok, Kwajalein"},
      {offset:"-1100", name: "(GMT -11:00) Midway Island, Samoa"},
      {offset:"-1000", name: "(GMT -10:00) Hawaii"},
      {offset:"-0900", name: "(GMT -9:00) Alaska"},
      {offset:"-0800", name: "(GMT -8:00) Pacific Time (US &Canada)"},
      {offset:"-0700", name: "(GMT -7:00) Mountain Time (US &Canada)"},
      {offset:"-0600", name: "(GMT -6:00) Central Time (US &Canada), Mexico City"},
      {offset:"-0500", name: "(GMT -5:00) Eastern Time (US &Canada), Bogota, Lima"},
      {offset:"-0400", name: "(GMT -4:00) Atlantic Time (Canada), Caracas, La Paz"},
      {offset:"-0350", name: "(GMT -3:30) Newfoundland"},
      {offset:"-0300", name: "(GMT -3:00) Brazil, Buenos Aires, Georgetown"},
      {offset:"-0200", name: "(GMT -2:00) Mid-Atlantic"},
      {offset:"-0100", name: "(GMT -1:00 hour) Azores, Cape Verde Islands"},
      {offset:"0000", name: "(GMT) Western Europe Time, London, Lisbon, Casablanca"},
      {offset:"+0100", name: "(GMT +1:00 hour) Brussels, Copenhagen, Madrid, Paris"},
      {offset:"+0200", name: "(GMT +2:00) Kaliningrad, South Africa"},
      {offset:"+0300", name: "(GMT +3:00) Baghdad, Riyadh, Moscow, St. Petersburg"},
      {offset:"+0350", name: "(GMT +3:30) Tehran"},
      {offset:"+0400", name: "(GMT +4:00) Abu Dhabi, Muscat, Baku, Tbilisi"},
      {offset:"+0450", name: "(GMT +4:30) Kabul"},
      {offset:"+0500", name: "(GMT +5:00) Ekaterinburg, Islamabad, Karachi, Tashkent"},
      {offset:"+0550", name: "(GMT +5:30) Bombay, Calcutta, Madras, New Delhi"},
      {offset:"+0570", name :"(GMT +5:45) Kathmandu"},
      {offset:"+0600", name: "(GMT +6:00) Almaty, Dhaka, Colombo"},
      {offset:"+0700", name: "(GMT +7:00) Bangkok, Hanoi, Jakarta"},
      {offset:"+0800", name: "(GMT +8:00) Beijing, Perth, Singapore, Hong Kong"},
      {offset:"+0900", name: "(GMT +9:00) Tokyo, Seoul, Osaka, Sapporo, Yakutsk"},
      {offset:"+0950", name: "(GMT +9:30) Adelaide, Darwin"},
      {offset:"+1000", name: "(GMT +10:00) Eastern Australia, Guam, Vladivostok"},
      {offset:"+1100", name: "(GMT +11:00) Magadan, Solomon Islands, New Caledonia"},
      {offset:"+1200", name: "(GMT +12:00) Auckland, Wellington, Fiji, Kamchatka"}
    ]

    value = scope.$eval(attrs.ngModel)
    if !value? || value == undefined # if tmiezone has not been set 
      dt = new Date()
      defaultOffset = dt.toString().substring(28,33)
      defaultTimezone = scope.timezone_list.find( (e)-> e.offset == defaultOffset )?.name

      model = $parse(attrs.ngModel)
      model.assign(scope, defaultTimezone);
      


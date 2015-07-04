@validateFormSearch = ->
  $('#searchForm').validate
    rules:
      "radius":
        min: 1
        max: 5
        number: true
      "lat":
        required: true
      "lng":
        required: true
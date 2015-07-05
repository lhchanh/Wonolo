geocoder = null
map = null
marker = null

@initializeGoogleMaps = ->
  geocoder = new google.maps.Geocoder()
  latlng = new google.maps.LatLng(10.8230989, 106.6296638)
  mapOptions =
    center: latlng
    zoom: 8

  mapDiv = document.getElementById('map-canvas')
  map = new (google.maps.Map)(mapDiv, mapOptions)

  marker = new (google.maps.Marker)
    position: latlng
    map: map
    title: 'Drag this icon to select new location'
    draggable: true

  updateLatLng(latlng.lat(), latlng.lng())

  google.maps.event.addListener marker, 'dragend', (location) ->
    if location
      updateLatLng(location.latLng.lat(), location.latLng.lng())
    return
  return

@getLatLngByAddress = ->
  address = document.getElementById('address').value
  return unless address
  geocoder.geocode { 'address': address }, (results, status) ->
    if status == google.maps.GeocoderStatus.OK
      location = results[0].geometry.location
      map.setCenter location
      if marker
        marker.setPosition(location)
      else
        marker = new (google.maps.Marker)
          map: map
          position: location
          draggable: true
      if location
        updateLatLng(location.lat(), location.lng())
      return
    else
      alert 'Geocode was not successful for the following reason: ' + status
    return
  return

updateLatLng = (lat, lng)->
  $('#latitude').val(lat)
  $('#longitude').val(lng)

@formatTime = ->
  $('.time').each (i, e) ->
    time = moment(parseInt($(e).attr('datetime'))*1000).fromNow()
    $(e).html '<span>' + time + '</span>'
  return

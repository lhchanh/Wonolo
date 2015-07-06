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

@triggerModal = ->
  $('.box-post .img-thumbnail').on 'click', ->
    clearDetailData()
    $('.wrap-feed-detail').hide()
    $('.loading').show()
    mediaID = $(this).parent('.thum-post').parent('.box-post').attr('media-id')
    if mediaID
      getPostByMediaID(mediaID)
  return

getPostByMediaID = (mediaID) ->
  $('#feed-post').modal('show')
  $('#feed-post').off 'shown.bs.modal'
  $('#feed-post').on 'shown.bs.modal', ->
    $.ajax
      url: Routes.get_post_path({media_id: mediaID})
      dataType: 'json'
      cache: false
      type: 'GET'
      success: (respondData) ->
        updateDetailData(respondData)
        formatTime()
        $('.loading').hide()
        $('.wrap-feed-detail').show()
        return
      error: (error)->
        $('.loading').show()
        $('.wrap-feed-detail').hide()

appendLikeUser = (element, data)->
  element.html('')
  html = '<ul>'
  i = 0
  while i < data.length
    html = html + '<li>
                      <img class="img-circle" src="' + data[i].profile_picture + '" />
                      <span class="full_name_user_like">' + data[i].full_name + '</span>
                  </li>'
    i++
  html = html + '</ul>'
  element.append(html)

appendComments = (element, data)->
  element.html('')
  html = '<ul>'
  i = 0
  while i < data.length
    html = html + '<li>
                      <img class="img-circle" src="' + data[0].from.profile_picture + '" />
                      <span class="content">'+ data[0].text + '</span>
                      <span class="time-coment time" datetime="' + data[0].created_time + '"></span>
                    </li>'
    i++
  html = html + '</ul>'
  element.append(html)

updateDetailData = (respondData)->
  $('.img_feed_post').attr("src", respondData.images.standard_resolution.url)
  $('.img_poster').attr("src", respondData.user.profile_picture)
  $('.full_name_poster').attr("href", respondData.link)
  $('.full_name_poster span.full_name').html(respondData.user.full_name)
  $('.created_time').attr("datetime", respondData.created_time)
  $('.count_like').html(respondData.likes.count)
  $('.count_comment').html(respondData.comments.count)
  if respondData.likes.count > 0
    dataLike = respondData.likes.data
    appendLikeUser($('.like_user'), dataLike)
  else
    $('.like_user').html('')

  if respondData.comments.count > 0
    data = respondData.comments.data
    appendComments($('.comment_list'), data)
  else
    $('.comment_list').html('')

clearDetailData = ->
  $('.full_name_poster').attr("href", '')
  $('.full_name_poster span.full_name').html('')
  $('.count_like').html('')
  $('.count_comment').html('')
  $('.like_user').html('')
  $('.comment_list').html('')
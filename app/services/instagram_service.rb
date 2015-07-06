class InstagramService < BaseService

  def search_posts params_search
    lat = params_search[:lat]
    lng = params_search[:lng]
    distance = params_search[:radius].to_i*1000 || RADIUS
    return [] unless (lat && lng)
    medias = @client.media_search(lat,lng, {distance: distance})
    medias = medias.each do |media|
      media_location = Geokit::Geocoders::GoogleGeocoder.geocode("#{media.location.latitude}, #{media.location.longitude}")
      source_location = Geokit::Geocoders::GoogleGeocoder.geocode("#{lat}, #{lng}")
      media.distance = media_location.distance_to(source_location)
    end
    .sort_by do |m|
      m.distance
    end
    Kaminari.paginate_array(medias).page(params_search[:page]).per(PER_PAGE)
  end

  def get_post media_id
    return nil unless media_id
    data = @client.media_item(media_id)
    data.comments.data = get_media_comments(media_id)
    data.likes.data = get_media_likes(media_id)
    data
  end

  [:likes, :comments].each do |sym|
    define_method("get_media_#{sym.to_s}") do |media_id|
      media_id ? @client.send("media_#{sym.to_s}", media_id) : []
    end
  end
end
class InstagramService < BaseService

  def search_posts params_search
    lat = params_search[:lat]
    lng = params_search[:lng]
    distance = params_search[:radius].to_i*1000 || RADIUS
    instagrams = if lat && lng
      instagrams = @client.media_search(lat,lng, {distance: distance})
      instagrams = instagrams.sort_by do |instagram|
        Geocoder::Calculations.bearing_between([instagram.location.latitude, instagram.location.longitude], [lat, lng])
      end.each { |e| e.distance = Geocoder::Calculations.bearing_between([e.location.latitude, e.location.longitude], [lat, lng])/1000}
      instagrams = Kaminari.paginate_array(instagrams).page(params_search[:page]).per(PER_PAGE)
    else
      []
    end
    instagrams
  end

  def get_post media_id
    post = nil
    post = @client.media_item(media_id) if media_id
  end

end
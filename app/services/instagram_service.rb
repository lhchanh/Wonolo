class InstagramService < BaseService

  def search_posts params_search
    lat = params_search[:lat]
    lng = params_search[:lng]
    distance = params_search[:radius].to_i*1000 || RADIUS
    instagrams = if lat && lng
      instagrams = @client.media_search(lat,lng, {distance: distance})
      instagrams = instagrams.each { |e| e.distance = Geocoder::Calculations.bearing_between("#{e.location.latitude}, #{e.location.longitude}", "#{lat}, #{lng}")}
          .sort_by do |e|
            # Fixed issue Usage Limits for Google Geocoding API
            # 5 requests per second.
            sleep  0.06
            e.distance
          end
      instagrams = Kaminari.paginate_array(instagrams).page(params_search[:page]).per(PER_PAGE)
    else
      []
    end
    instagrams
  end

  def get_post media_id
    @client.media_item(media_id) if media_id
  end

  [:likes, :comments].each do |sym|
    define_method("get_media_#{sym.to_s}") do |media_id|
      media_id ? @client.send("media_#{sym.to_s}", media_id) : []
    end
  end
end
class InstagramService < BaseService

  def search_posts params_search
    lat = params_search[:lat]
    lng = params_search[:lng]
    distance = params_search[:radius].to_i*1000 || RADIUS
    instagrams = if lat && lng
      instagrams = @client.media_search(lat,lng, {distance: distance})
      instagrams = instagrams.each do |e|
            distance = ''
            while !distance.is_a? Numeric
              begin
                sleep 1
                distance = Geocoder::Calculations.bearing_between("#{e.location.latitude}, #{e.location.longitude}", "#{lat}, #{lng}")
              rescue
                # Fixed issue Usage Limits for Google Geocoding API
                # 5 requests per second.
                sleep 2
                distance = Geocoder::Calculations.bearing_between("#{e.location.latitude}, #{e.location.longitude}", "#{lat}, #{lng}").to_f
              end
            end
            e.distance = distance
          end
          .sort_by do |e|
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
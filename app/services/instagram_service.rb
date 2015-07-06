class InstagramService < BaseService

  def search_posts params_search
    lat = params_search[:lat]
    lng = params_search[:lng]
    distance = params_search[:radius].to_i*1000 || RADIUS
    return [] unless (lat && lng)
    medias = @client.media_search(lat,lng, {distance: distance})
    medias = medias.each do |e|
          distance = ''
          while !distance.is_a? Numeric
            begin
              sleep 2
              distance = Geocoder::Calculations.bearing_between("#{e.location.latitude}, #{e.location.longitude}", "#{lat}, #{lng}")
            rescue
              # Fixed issue Usage Limits for Google Geocoding API
              # 5 requests per second.
              sleep 5
              distance = Geocoder::Calculations.bearing_between("#{e.location.latitude}, #{e.location.longitude}", "#{lat}, #{lng}").to_f
            end
          end
          e.distance = distance
        end
        .sort_by do |e|
          e.distance
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
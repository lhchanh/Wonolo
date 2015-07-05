class InstagramService < BaseService

  def search_posts params_search
    lat = params_search[:lat]
    lng = params_search[:lng]
    distance = params_search[:radius].to_i*1000 || RADIUS
    instagrams = if lat && lng
      instagrams = @client.media_search(lat,lng, {distance: distance})
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
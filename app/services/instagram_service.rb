class InstagramService < BaseService

  def search_posts params_search
    lat = params_search[:lat]
    lng = params_search[:lng]
    distance = params_search[:radius].to_i*1000 || RADIUS
    instagrams = if lat && lng
      instagrams = Instagram.client(access_token: ACCESS_TOKEN_INSTAGRAM)
      instagrams = instagrams.media_search(lat,lng, {distance: distance})
      instagrams = Kaminari.paginate_array(instagrams).page(params_search[:page]).per(PER_PAGE)
    else
      []
    end
    instagrams
  end

end
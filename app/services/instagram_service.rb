class InstagramService < BaseService

  def search_posts params_search
    lat = params_search[:lat]
    lng = params_search[:lng]
    distance = params_search[:radius].to_i*1000 || RADIUS
    instagrams = if lat && lng
      instagrams= Instagram.client(access_token: ACCESS_TOKEN_INSTAGRAM)
      instagrams=instagrams.media_search(lat,lng, {count: 10})
      p instagrams
      instagrams
    else
      []
    end
    instagrams
  end

end
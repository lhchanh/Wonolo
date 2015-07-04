class InstagramService < BaseService

  def search_posts
    instagram = Instagram.client(access_token: ACCESS_TOKEN_INSTAGRAM)
    @instagram = instagram.media_search("37.7808851","-122.3948632")
  end

end
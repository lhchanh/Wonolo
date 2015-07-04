class HomeController < ApplicationController

  def index
    @instagrams = instagram_service.search_posts params
  end

  private
  def instagram_service
    @service ||= InstagramService.new
  end

end

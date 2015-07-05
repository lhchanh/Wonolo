class HomeController < ApplicationController

  def index
    @instagrams = instagram_service.search_posts params
  end

  def get_post
    result = instagram_service.get_post params[:media_id]
    render json: result
  end

  private
  def instagram_service
    @service ||= InstagramService.new
  end

end

class HomeController < ApplicationController

  def index
    @instagrams = instagram_service.search_posts params
  end

  def get_post
    result = instagram_service.get_post params[:media_id]
    render json: result
  end

  def get_media_like
    result = instagram_service.get_media_like params[:media_id]
    render json: result
  end

  private
  def instagram_service
    @service ||= InstagramService.new
  end

end

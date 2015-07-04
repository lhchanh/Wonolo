class HomeController < ApplicationController

  def index
    @instagram = instagram_service.search_posts
  end

  private
  def instagram_service
    @service ||= InstagramService.new
  end

end

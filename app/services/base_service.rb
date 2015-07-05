class BaseService
  attr_accessor :current_user
  def initialize current_user=nil
    @current_user = current_user
    @client = Instagram.client(access_token: ACCESS_TOKEN_INSTAGRAM)
  end
end
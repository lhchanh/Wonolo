Rails.application.routes.draw do

  root 'home#index'
  get "get_post" => 'home#get_post'
  get "get_media_like" => 'home#get_media_like'

end

Rails.application.routes.draw do

  root 'home#index'
  get "get_post" => 'home#get_post'

end

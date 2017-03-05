Rails.application.routes.draw do
  devise_for :user
  
  resources :user

  get 'books/top' => 'books#top'
  
  get 'books/detail' => 'books#detail'
  
  #  post 'books/api' => 'books#api'
  
  post 'books/search_result' => 'books#search_result'

#  get 'user/show' => 'user#show'

  root 'home#top'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

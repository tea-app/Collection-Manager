Rails.application.routes.draw do
  devise_for :users
  get 'books/top'
  
  get 'books/detail'

  get 'user/show'

  get 'home/top'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

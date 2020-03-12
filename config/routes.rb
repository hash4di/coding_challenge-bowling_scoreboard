Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root   'games#index'

  namespace :api do
    namespace :v1 do
      resources :games, only: [:index, :create, :show, :update, :destroy]
    end
  end
  
  resources :games, only: [:index, :create, :show, :update, :destroy]

end
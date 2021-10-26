Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'
      get '/merchants/find_all', to: 'merchants#find_all'
      resources :merchants, only: [:index, :show]
      get '/merchants/:id/items', to: 'merchant_items#index'

      get '/items/find', to: 'items#find'
      get '/items/find_all', to: 'items#find_all'
      resources :items
      get '/items/:id/merchant', to: 'item_merchants#show'

      get '/revenue/merchants/:id', to: 'revenue#show'
      get '/revenue/merchants', to: 'revenue#quantity_merchants'
    end
  end
end

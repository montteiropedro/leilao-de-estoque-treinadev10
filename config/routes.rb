Rails.application.routes.draw do
  devise_for :users
  
  root "home#index"
  resources :batches, only: [:index, :show, :new, :create] do
    member do
      post 'approve'
      patch 'add_product'
    end
  end
  resources :products, only: [:index, :show, :new, :create, :update]
  resources :categories, only: [:index, :show, :new, :create]
end

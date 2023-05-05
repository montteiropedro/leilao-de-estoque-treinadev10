Rails.application.routes.draw do
  devise_for :users
  
  root "home#index"
  resources :batches, only: [:index, :show, :new, :create]
  resources :products, only: [:index, :show, :new, :create]
  resources :categories, only: [:index, :show, :new, :create]
end

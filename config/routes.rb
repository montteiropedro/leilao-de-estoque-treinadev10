Rails.application.routes.draw do
  devise_for :users
  
  root "home#index"
  resources :batches, only: [:index, :show, :new, :create]
  resources :products, only: [:index, :new, :create]
  resources :categories, only: [:index, :new, :create]
end

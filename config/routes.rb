Rails.application.routes.draw do
  devise_for :users
  
  root "home#index"
  resources :batches, only: [:index, :show, :new, :create] do
    resources :bids, only: [:create]
    get 'expired', on: :collection
    member do
      post 'approve'
      patch 'add_product'
      delete 'cancel'
    end
  end
  resources :products, only: [:index, :show, :new, :create, :update] do
    member do
      patch 'link_batch'
      patch 'unlink_batch'
    end
  end
  resources :categories, only: [:index, :show, :new, :create]
end

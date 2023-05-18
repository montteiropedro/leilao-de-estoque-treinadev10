Rails.application.routes.draw do
  devise_for :users
  
  root "home#index"
  resources :blocked_cpfs, only: [:index, :create, :destroy]
  resources :lots, only: [:index, :show, :new, :create] do
    resources :bids, only: [:create]
    collection do
      get 'expired'
      get 'won'
      get 'search'
    end
    member do
      post 'approve'
      patch 'close'
      delete 'cancel'
      patch 'add_product'
    end
  end
  resources :products, only: [:index, :show, :new, :create, :update] do
    member do
      patch 'link_lot'
      patch 'unlink_lot'
    end
  end
  resources :categories, only: [:index, :show, :new, :create]
end

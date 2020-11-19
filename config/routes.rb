Rails.application.routes.draw do
  get 'homepages/index'
  get 'product/index'
  get 'product/show'
  get 'product/new'
  get 'product/edit'
  get 'product/create'
  get 'product/update'
  get 'product/destroy'
  get 'merchants/index'
  get 'merchants/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmlget "/auth/github", as: "github_login" #OmniAuth login

  get "/auth/github", as: "github_login" #OmniAuth login
  get "/auth/:provider/callback", to: "merchants#create" #OmniAuth Github callback
  post "/logout", to: "merchants#logout", as: "logout"

  root to: "homepages#index"

  resources :homepages, only: [:index]
  resources :merchants
  resources :products
  resources :categorizations
  resources :order_items
  resources :orders
  resources :reviews
end

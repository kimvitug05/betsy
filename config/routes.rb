Rails.application.routes.draw do
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
  get "/auth/:provider/callback", to: "users#create" #OmniAuth Github callback
  post "/logout", to: "users#logout", as: "logout"

  resources :merchants
  resources :products
  resources :categorizations
  resources :order_items
  resources :orders
  resources :reviews
end

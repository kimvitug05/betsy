Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmlget "/auth/github", as: "github_login" #OmniAuth login

  get "/auth/github", as: "github_login" #OmniAuth login
  get "/auth/:provider/callback", to: "merchants#create" #OmniAuth Github callback
  post "/logout", to: "merchants#logout", as: "logout"

  root to: "homepages#index"

  resources :homepages, only: [:index]
  resources :merchants, only: [:create, :index, :show]
  get "/dashboard", to: "merchants#dashboard", as: "dashboard"
  resources :products
  resources :categorizations
  resources :order_items
  resources :orders
  resources :reviews
end

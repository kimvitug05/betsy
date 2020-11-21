Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmlget "/auth/github", as: "github_login" #OmniAuth login

  get "/auth/github", as: "github_login" #OmniAuth login
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback" #OmniAuth Github callback
  post "/logout", to: "merchants#logout", as: "logout"

  resources :products, except: [:delete]

  get "/checkout", to: "orders#edit", as: "checkout"
  get "/cart", to:"order_items#cart", as: "cart"

  post "/add_to_cart", to:"order_items#add_to_cart", as: "add_to_cart"
  get "/clear_cart", to:"order_items#clear_cart", as: "clear_cart"
  root to: "homepages#index"

  resources :homepages, only: [:index]
  resources :merchants, only: [:create, :index, :show]
  get "/dashboard", to: "merchants#dashboard", as: "dashboard"

  resources :categorizations
  # resources :order_items
  resources :orders
  resources :reviews
end

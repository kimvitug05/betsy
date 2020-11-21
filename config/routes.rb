Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmlget "/auth/github", as: "github_login" #OmniAuth login

  get "/auth/github", as: "github_login" #OmniAuth login
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback" #OmniAuth Github callback
  post "/logout", to: "merchants#logout", as: "logout"

  resources :products, except: [:delete]

  get "/checkout", to: "orders#edit", as: "checkout"
  get "/cart", to:"products#cart", as: "cart"

  post "/add_to_cart", to:"products#add_to_cart", as: "add_to_cart"
  get "/clear_cart", to:"products#clear_cart", as: "clear_cart"
  root to: "homepages#index"

  resources :homepages, only: [:index]

  resources :merchants, only: [:create, :index, :show]
  resources :merchants do
    resources :products, only: [:new, :create, :edit, :update]
  end

  get "/dashboard", to: "merchants#dashboard", as: "dashboard"

  resources :categorizations
  # resources :order_items
  resources :orders
  resources :reviews
end

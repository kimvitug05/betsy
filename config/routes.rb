Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmlget "/auth/github", as: "github_login" #OmniAuth login

  get "/auth/github", as: "github_login" #OmniAuth login
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback" #OmniAuth Github callback
  post "/logout", to: "merchants#logout", as: "logout"

  resources :products, except: [:delete] do
    # post "/products/:product_id/order_items", to: "order_items#create", as: "start_shopping"
    get "products/shopping_cart", to: "products#shopping_cart", as: "shopping_cart"
    post 'products/add_to_cart/id', to: 'products#add_to_cart', as: "add_to_cart"
    delete 'products/remove_from_cart/id', to: 'products#remove_from_cart', as: "remove_from_cart"

  end

  root to: "homepages#index"

  resources :homepages, only: [:index]
  resources :merchants, only: [:create, :index, :show]
  get "/dashboard", to: "merchants#dashboard", as: "dashboard"

  resources :categorizations
  # resources :order_items
  resources :orders
  resources :reviews
end

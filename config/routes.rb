Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmlget "/auth/github", as: "github_login" #OmniAuth login

  get "/auth/github", as: "github_login" #OmniAuth login
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback" #OmniAuth Github callback
  post "/logout", to: "merchants#logout", as: "logout"

  resources :products, except: [:delete]

  get "/checkout", to: "orders#checkout", as: "checkout"
  get "/cart", to:"orders#cart", as: "cart"

  post "cart/add_one/:order_item", to:"order_items#add_one", as: "add_one"
  post "cart/less_one/:order_item", to:"order_items#less_one", as: "less_one"
  post "cart/remove/:order_item", to:"order_items#remove", as: "remove"
  post "/add_to_cart", to:"order_items#add_to_cart", as: "add_to_cart"
  post "/orders/submit", to:"orders#update", as:"submit_order"
  get "/clear_cart", to:"orders#clear_cart", as: "clear_cart"

  root to: "homepages#index"

  resources :homepages, only: [:index]

  resources :merchants, only: [:create, :index, :show]
  resources :merchants do
    resources :products, only: [:new, :edit]
  end

  get "/dashboard", to: "merchants#dashboard", as: "dashboard"
  get "/dashboard/products", to: "merchants#dashboard_products", as: "dashboard_products"
  put "/dashboard/products/retire/:id", to: "products#retire", as: "retire_product"
  put "/dashboard/products/restore/:id", to: "products#restore", as: "restore_product"

  resources :categorizations
  resources :orders
  resources :reviews
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmlget "/auth/github", as: "github_login" #OmniAuth login

  get "/auth/github", as: "github_login" #OmniAuth login
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback" #OmniAuth Github callback
  post "/logout", to: "merchants#logout", as: "logout"

  resources :products, except: [:delete]

  get "/checkout", to: "orders#edit", as: "checkout"
  get "/cart", to:"order_items#cart", as: "cart"

  post "cart/add_one/:product", to:"order_items#add_one", as: "add_one"
  post "cart/less_one/:product", to:"order_items#less_one", as: "less_one"
  post "cart/remove/:product", to:"order_items#remove", as: "remove"
  post "/add_to_cart", to:"order_items#add_to_cart", as: "add_to_cart"
  get "/clear_cart", to:"order_items#clear_cart", as: "clear_cart"

  root to: "homepages#index"

  resources :homepages, only: [:index]
  get "/about_us", to: "homepages#about_us", as: "about_us"
  get "/contact_us", to: "homepages#contact_us", as: "contact_us"

  resources :merchants, only: [:create, :index, :show]
  resources :merchants do
    resources :products, only: [:new, :edit]
  end

  get "/dashboard", to: "merchants#dashboard", as: "dashboard"
  get "/dashboard/products", to: "merchants#dashboard_products", as: "dashboard_products"
  put "/dashboard/products/retire/:id", to: "products#retire", as: "retire_product"
  put "/dashboard/products/restore/:id", to: "products#restore", as: "restore_product"

  resources :categorizations
  resources :order_items #TODO: If you don't need all of these, I just need to be able to update order_item
  resources :orders
  resources :reviews
end

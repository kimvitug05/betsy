Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmlget "/auth/github", as: "github_login" #OmniAuth login

  #Paths for Github Auth
  get "/auth/github", as: "github_login" #OmniAuth login
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback" #OmniAuth Github callback
  post "/logout", to: "merchants#logout", as: "logout"

  #Routes related to shopping cart
  get "/cart", to:"orders#cart", as: "cart" #cart page
  post "/add_to_cart", to:"order_items#add_to_cart", as: "add_to_cart" #add product to cart from show page

    #editing cart from cart page
    post "cart/add_one/:order_item", to:"order_items#add_one", as: "add_one"
    post "cart/less_one/:order_item", to:"order_items#less_one", as: "less_one"
    post "cart/remove/:order_item", to:"order_items#remove", as: "remove"
    get "/clear_cart", to:"orders#clear_cart", as: "clear_cart"

  #checkout items path
  get "/checkout", to: "orders#checkout", as: "checkout" #path to go to cart for checkout
  post "/orders/submit", to:"orders#update", as:"submit_order" #path to submit order

  root to: "homepages#index"

  resources :homepages, only: [:index]
  get "/about_us", to: "homepages#about_us", as: "about_us"
  get "/contact_us", to: "homepages#contact_us", as: "contact_us"

  resources :merchants, only: [:create, :index, :show]
  resources :merchants do
    resources :products, only: [:new, :edit]
  end

  resources :products do
    resources :reviews, only: [:index, :show, :new, :create]
  end

  #Dashboard paths
  get "/dashboard", to: "merchants#dashboard", as: "dashboard"
  get "/dashboard/products", to: "merchants#dashboard_products", as: "dashboard_products"
  put "/dashboard/products/retire/:id", to: "products#retire", as: "retire_product"
  put "/dashboard/products/restore/:id", to: "products#restore", as: "restore_product"


  #standard RESTFUL routes
  resources :categorizations
  resources :order_items #TODO: If you don't need all of these, I just need to be able to update order_item
  resources :orders
  resources :reviews
  resources :products, except: [:delete] #TODO: I think this one is redundant

end

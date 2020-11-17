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
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

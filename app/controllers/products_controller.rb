class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :archive]
  before_action :require_login, except: [:index, :show]

  def index
    @products = Product.all
  end

  def show
    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def new
    @product = Product.new
    @quantity = @product.quantity

    if @product.quantity.nil?
      @quantity = 0
    end
  end

  def edit
    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def create
    @product = Product.new(product_params)
    @product.merchant_id = session[:user_id]

    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created new product: #{@product.name}"
      redirect_to product_path(@product.id)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@product}"
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  def update
    if @product.nil?
      redirect_to products_path
      return
    end

    if @product.update(product_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@product.id}"
      redirect_to product_path(@product)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Something went wrong.  Could not update #{@product.name}"
      flash.now[:messages] = @product.errors.messages
      render :edit, status: :bad_request
    end
  end

  # archive product
  def archive
    @product.active = false
    @product.save
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :quantity, :active, :description, :photo, categorization_ids: []).with_defaults(merchant_id: @login_user.id)
  end

  def find_product
    @product = Product.find_by_id(params[:id])
  end

end

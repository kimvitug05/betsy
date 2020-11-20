class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update]
  # skip_before_action :require_login, except [:new, :edit, :destroy]

  def index
    @products = Product.all
  end

  def show
    render_404 unless @product
  end

  def new
    @product = Product.new
  end

  def edit
    # if @product.nil?
    #   redirect_to products_path
    #   return
    # end
  end

  def create
    unless session[:merchant_id]
      flash[:status] = :failure
      flash[:result_text] = "Only merchants can create a new product"
      render :index, status: :forbidden
      return
    end

    @product = Product.new(product_params)
    @product.merchant_id = session[:merchant.id] #<--will this work? Or need to declare @merchant?
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created new product: #{@product.name}"
      redirect_to product_path(@product)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@product}"
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  def update
    if @product.update(product_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@product.id}"
      redirect_to product_path(@product)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update #{@product}"
      flash.now[:messages] = @product.errors.messages
      render :edit, status: :not_found
    end
  end

  #TODO def retire?

  private

  def product_params
    return params.require(:product).permit(:name, :price, :merchant_id, :quantity, :status)
  end

  def find_product
    @product = Product.find_by_id(id: params[:id])
  end
end

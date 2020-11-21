class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update]
  # skip_before_action :require_login, except [:new, :edit, :destroy]

  def index
    @products = Product.all
  end

  def show
    render_404 unless @product
  end

  def cart
    @cart = session[:cart].map { |attributes| OrderItem.new(attributes)}
    @cart_total = get_total
  end

  def get_total
    total = 0.0
    @cart.each do |item|
      total = total + item.product.price * item.quantity
    end
    return total
  end

  def clear_cart
    session[:cart] = []

    redirect_to cart_path
  end

  def add_to_cart
    initialize_session
    product = find_product
    quantity = params[:selected_quantity].to_i
    if product.quantity.nil?
      product.quantity = 0
      product.save
    end
    if quantity > product.quantity.to_i
      quantity = product.quantity #if more is added than is available, add remaining
    end

    order_item = OrderItem.new(product: product, quantity: quantity)
    # product_hash = {"product"=> product, "selected_quantity"=>quantity}
    session[:cart]  << order_item
    redirect_to cart_path
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
    unless session[:user_id]
      flash[:status] = :failure
      flash[:result_text] = "Only merchants can create a new product"
      render :index, status: :forbidden
      return
    end

    @product = Product.new(product_params)
    @product.merchant_id = session[:user_id]
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
    unless session[:user_id]
      flash[:status] = :failure
      flash[:result_text] = "Only merchants can update a product"
      render :index, status: :forbidden
      return
    end

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

  def initialize_session
    return session[:cart] ||= []
  end

  def product_params
    return params.require(:product).permit(:name, :price, :quantity, :active, :description, :photo)
  end

  def find_product
    @product = Product.find_by(id: params[:product_id])
  end

end

class OrdersController < ApplicationController
  
  
    def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.order_items = session[:cart].map { |attributes| OrderItem.new(attributes)}
    if @order.save
      flash[:status] = :success
      flash[:result_text] = "Successfully ordered: #{@order.id}"
      redirect_to order_path(@order)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@order}"
      flash[:messages] = @order.errors.messages
      render :new, status: :bad_request
    end
  end

    def edit
      @order = Order.new
    end

    def cart
      @cart = session[:cart]
      @cart_total = get_total
    end

    def get_total
      total = 0.0
      @cart.each do |item|
        total = total + item['product']['price'] * item['selected_quantity']
      end
      return total
    end

    def clear_cart
      session[:cart] = []
      @cart = {}
      redirect_to cart_path
    end


    def add_to_cart
      initialize_session
      product = Product.find_by(id: params[:product_id])
      quantity = params[:selected_quantity].to_i
      if product.quantity.nil?
        product.quantity = 0
        product.save
      end
      if quantity > product.quantity.to_i
        quantity = product.quantity #if more is added than is available, add remaining
      end

      product_hash = {"product"=> product, "selected_quantity"=>quantity}
      session[:cart]  << product_hash
      redirect_to cart_path
    end

  private

  def order_params
    return params.require(:order).permit(:name, :email, :address, :zip_code, :credit_card, :exp_date)
  end

  def find_order
    @order = Order.find_by_id(id: params[:id])
  end

    def initialize_session
      return session[:cart] ||= []
    end
end

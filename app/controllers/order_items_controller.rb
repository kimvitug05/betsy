class OrderItemsController < ApplicationController

  def create
    @order_items = current_order
  end

    def cart
      @cart = session[:cart].map { |attributes| OrderItem.new(attributes)}
      @cart_total = get_total
    end

  def add_to_cart
    initialize_session
    product = Product.find_by(id: params["product_id"])
    quantity = params["selected_quantity"].to_i
    if product.quantity.nil?
      product.quantity = 0
      product.save
    end
    if quantity > product.quantity.to_i
      quantity = product.quantity #if more is added than is available, add remaining
    end

    order_item = OrderItem.new(product_id: product.id, quantity: quantity)
    session[:cart]  << order_item
    redirect_to cart_path
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
  def update

  end

  private

  def initialize_session
    return session[:cart] ||= []
  end

end

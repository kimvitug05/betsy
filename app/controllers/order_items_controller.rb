class OrderItemsController < ApplicationController

  def create
    @order_items = current_order
  end

    def cart
      @cart = session[:cart].map { |attributes| OrderItem.new(attributes)}
      # @cart = session[:cart]
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

      # find the item in the cart
      # update the quantity
    if session[:cart].empty?
      session[:cart]  << order_item
    else
      #cart is not empty
      if cart_has_item (order_item)
        session[:cart].each do |item|
            if item["product_id"] == order_item.product_id
             item["quantity"] = item["quantity"] + quantity
            end
        end
      else
        session[:cart]  << order_item
      end
    end
    redirect_to cart_path
  end

  def remove
    item_to_remove = params[:product].to_i
    session[:cart].each do |item|
      if item["product_id"] == item_to_remove
        session[:cart].delete(item)
      end
    end

    redirect_to cart_path
  end

  def add_one
    product_id = params[:product].to_i
    product = Product.find_by(id: product_id)
    session[:cart].each do |item|
      if item["product_id"] == product_id
        if item["quantity"] < product.quantity
          item["quantity"] = item["quantity"] + 1
        end
      end
    end
    redirect_to cart_path
  end

  def less_one
    product_id = params[:product].to_i
    session[:cart].each do |item|
      if item["product_id"] == product_id
        if item["quantity"] > 1
          item["quantity"] = item["quantity"] - 1
        end
      end
    end
    redirect_to cart_path
  end

  def cart_has_item(test_item)
    session[:cart].each do |item|
      if item["product_id"] == test_item.product_id
        return true
      end
    end
    return false
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

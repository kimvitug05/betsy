class OrderItemsController < ApplicationController




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

    #verify merchant is not buying own product
    if !can_purchase(product)
      redirect_to products_path
      return
    end
    order = session[:order_id]? Order.find_by(id: session[:order_id]) : create_order
    order_item = OrderItem.new(product_id: product.id,order_id: order.id, quantity: quantity)
    if order_item.save
      session[:cart] << order_item
    end
      # find the item in the cart
      # update the quantity
    # if session[:cart].empty?
    #   session[:cart]  << order_item
    #     flash[:status] = :success
    #     flash[:result_text] = "Awesome! Your N.E.O.P.E.T.S.Y #{product.name} item is in the cart!"
    # else
    #   #cart is not empty
    #   if cart_has_item(order_item)
    #     session[:cart].each do |item|
    #         if item["product_id"] == order_item.product_id
    #          item["quantity"] = item["quantity"] + quantity
    #         end
    #         flash[:status] = :success
    #         flash[:result_text] = "Awesome! Your N.E.O.P.E.T.S.Y #{product.name} quantity has been updated!"
    #     end
    #   else
    #     session[:cart]  << order_item
    #     flash[:status] = :success
    #     flash[:result_text] = "Great choice! We've added another N.E.O.P.E.T.S.Y. item to your cart!"
    #   end
    # end
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

  def can_purchase(product)
    if session[:user_id] == product.merchant_id
      flash[:status] = :failure
      flash[:result_text] = "Merchants cannot buy their own products."
      return false
    end
    true
  end

  def create_order
    order = Order.new
    unless order.save
      flash[:error] = "Something went wrong: #{order.errors.messages}"
    end
    session[:order_id] = order.id
    order.reload
    return order
  end


  def update

  end

  private

  def order_items_params
    return params.require(:order_items).permit(:product_id, :order_id, :quantity)
  end


  def initialize_session
    return session[:cart] ||= []
  end

end

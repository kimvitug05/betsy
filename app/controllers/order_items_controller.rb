class OrderItemsController < ApplicationController
  # TODO: Does this need any validations?

  def add_to_cart
    initialize_session
    product = Product.find_by(id: params["product_id"])
    quantity = params["selected_quantity"].to_i
    if product.quantity.nil? || product.quantity < 0
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

    if !order.order_items.find_by(product_id:product.id).nil?
      order_item = order.order_items.find_by(product_id:product.id)
      already_in_cart = order_item.quantity
      available = product.quantity -  already_in_cart
      if quantity <= available
        order_item.quantity += quantity
      end
      order_item.save
              flash[:status] = :success
              flash[:result_text] = "Awesome! Your N.E.O.P.E.T.S.Y #{product.name} quantity has been updated!"
    else
      order_item = OrderItem.new(product_id: product.id,order_id: order.id, quantity: quantity)
      if order_item.save
        order.order_items << order_item
            flash[:status] = :success
            flash[:result_text] = "Awesome! Your N.E.O.P.E.T.S.Y #{product.name} item is in the cart!"
      end
    end
    product.quantity -= quantity
    product.save
    redirect_to cart_path
  end

  def remove
    order_item_id = params[:order_item].to_i
    order_item = OrderItem.find_by(id: order_item_id)
    order_item.product.quantity += order_item.quantity
    order_item.product.save
    order_item.destroy
    redirect_to cart_path
  end

  def add_one
    order_item_id = params[:order_item].to_i
    order_item = OrderItem.find_by(id: order_item_id)
    if order_item.product.quantity > 0
      order_item.quantity += 1
      order_item.product.quantity -= 1
      order_item.save
      order_item.product.save
    end
    redirect_to cart_path
  end

  def less_one
    order_item_id = params[:order_item].to_i
    order_item = OrderItem.find_by(id: order_item_id)
    if order_item.quantity > 1
      order_item.quantity -= 1
      order_item.product.quantity += 1
      order_item.save
      order_item.product.save
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
    unless order.save(:validate => false)
      flash[:error] = "Something went wrong: #{order.errors.messages}"
    end
    session[:order_id] = order.id
    order.reload
    return order
  end

  def update
    unless @login_user
      flash[:status] = :failure
      flash[:result_text] = "Only merchants can update an order item."
      redirect_to root_path
      return
    end

    @order_item = OrderItem.find_by(id: params[:id])

    if order_item_update_params.permitted? # if strong params
      @order_item.update(status: "shipped") # adjust status

      if @order_item.order.order_items.all? { |order_item| order_item.status == "shipped" } # all items in order now shipped, update order status
        @order_item.order.update(status: "complete")
      end

      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@order_item.product.name} order item(s)."
      redirect_to order_path(@order_item.order.id)
    end
  end

  private

  def order_items_params
    return params.require(:order_items).permit(:product_id, :order_id, :quantity)
  end


  def initialize_session
    return session[:cart] ||= []
  end

  def order_item_update_params #TODO: This is also for updating status on merchant dash
    return params.require(:order_item).permit(:status)
  end

end

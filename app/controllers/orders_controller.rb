class OrdersController < ApplicationController

  # TODO ----> attempted merge of the two versions before Kayla's most recent update
  #
  # before_action :find_order

  def new
    @order = Order.new
  end

  # def create
  #   @order = Order.new(order_params)
  #   @order.order_items = session[:cart].map { |attributes| OrderItem.new(attributes)}
  #
  #   #TODO at this point has the application already prevented products not in stock from being ordered?
  #
  #   if @order.save
  #     @order.order_items.each do |order_item| # Adjust merchant quantity
  #       order_item.product.quantity -= order_item.quantity # adjust quantity
  #       order_item.product.save # save
  #     end
  #
  #     @order.update(status: "paid") # TODO: Kayla, please adjust this if you need w refactor, but make sure that when merchant looks at brand new order, should be 'paid' at that point
  #     flash[:status] = :success
  #     flash[:result_text] = "Your order has been processed. Thank you for your purchase! Your confirmation no. is ##{@order.id}"
  #     redirect_to order_path(@order)
  #   else
  #     flash[:status] = :failure
  #     flash[:result_text] = "Something went wrong. Could not create order ##{@order.id}"
  #     flash[:messages] = @order.errors.messages
  #     render :new, status: :bad_request
  #   end
  # end

  def checkout
    @order = Order.find_by(id: session[:order_id])
    @cart_total = get_total
  end


  # def create
  #   @order = Order.new(order_params)
  #   @order.order_items = session[:cart].map { |attributes| OrderItem.new(attributes)}
  #   if @order.save
  #     flash[:status] = :success
  #     flash[:result_text] = "Your order has been processed. Thank you for your purchase! Your confirmation no. is ##{@order.id}"
  #     redirect_to order_path(@order)
  #   else
  #     flash[:status] = :failure
  #     flash[:result_text] = "Something went wrong. Could not create order ##{@order.id}"
  #     flash[:messages] = @order.errors.messages
  #     render :new, status: :bad_request

  # def update #TODO this is outdated, re Ansel suggestions to switch to shipped buttons on dashboard
  #   unless @login_user
  #     flash[:status] = :failure
  #     flash[:result_text] = "Only merchants can update an order"
  #     render :index, status: :forbidden
  #     return
  #   end
  #
  #   find_order
  #
  #   if order_update_params.permitted? #if strong params
  #     # if params[:order][:status] == "complete" #if marking complete, must update inventory
  #     #   if @order.extract_merchant_order_items(@login_user.id).any? { |order_item| order_item.quantity > order_item.product.quantity } #if filling order would bring product stock below 0
  #     #     flash[:status] = :failure
  #     #     flash[:result_text] = "Error: Not enough product stock to fill this order.  Please update stock first."
  #     #     redirect_to order_path(@order)
  #     #     return
  #     #   else # otherwise, mark order complete and adjust inventory
  #     #     @order.extract_merchant_order_items(@login_user.id).each do |order_item|
  #     #       order_item.product.quantity -= order_item.quantity # adjust quantity
  #     #     end
  #     #     @order.extract_merchant_order_items(@login_user.id).each do |order_item|
  #     #       order_item.update!(status: "complete") # adjust status
  #     #     end
  #     #
  #     #     if @order.order_items.each { |order_item| order_item.status == params[:order][:status] } # if all order_items have the same status
  #     #       @order.status = params[:order][:status] # then can change the order status officially to the customer as each merchant has marked the order at the same phase
  #     #     end
  #     #
  #     #     flash[:status] = :success
  #     #     flash[:result_text] = "Successfully updated order ##{@order.id}.  Inventory has been removed from stock."
  #     #     redirect_to order_path(@order)
  #     #   end
  #
  #     # else # for all other statuses, don't need to adjust inventory, just status
  #       @order.extract_merchant_order_items(@login_user.id).each do |order_item|
  #         order_item.update(status: params[:order][:status]) # adjust status
  #       end
  #
  #       if @order.order_items.each { |order_item| order_item.status == params[:order][:status] } # if all order_items have the same status
  #         @order.status = params[:order][:status] # then can change the order status officially to the customer as each merchant has marked the order at the same phase
  #       end
  #
  #       flash[:status] = :success
  #       flash[:result_text] = "Successfully updated order ##{@order.id}"
  #       redirect_to order_path(@order)
  #     # end
  #   else # order params not permitted
  #     flash.now[:status] = :failure
  #     flash.now[:result_text] = "Could not update order ##{@order.id}"
  #     flash.now[:messages] = @order.errors.messages
  #     redirect_to dashboard_path
  #   end
  # end

  def cart
    @order = Order.find_by(id: session[:order_id])
    @cart_total = get_total
  end

  def get_total
    total = 0.0
    if !@order.nil?
      @order.order_items.each do |item|
        total = total + item.product.price * item.quantity
      end
    end
    return total.to_f
  end

  def clear_cart
    @order = Order.find_by(id: session[:order_id])
    if !@order.nil?
      @order.order_items.each do |item|
        item.product.quantity += item.quantity
        item.product.save
        item.destroy
      end
    end
    session[:order_id] = nil
    redirect_to cart_path
  end

  def submit
    @order = Order.find_by(id: params[:order])
    @order.name = order['name']

  end

  # def edit
  #   @order = Order.new
  # end

  def update #TODO: If we want to be able to change order status
    # unless @login_user
    #   flash[:status] = :failure
    #   flash[:result_text] = "Only merchants can update an order"
    #   render :index, status: :forbidden
    #   return
    # end

    @order = Order.find_by(id: session[:order_id])

    if @order.update(order_params)
      @order.status = "paid"
      @order.save
      flash[:status] = :success
      flash[:result_text] = "Successfully updated order ##{@order.id}"
      session[:order_id] = nil
      redirect_to order_path(@order)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not update order ##{@order.id}"
      flash[:messages] = @order.errors.messages
      redirect_to checkout_path(@order)
    end
  end

  def show
    order_id = params[:id].to_i
    @order = Order.find_by(id: order_id)

    if @order.nil?
      render render_404
      return
    end
  end


  private

  def order_params #For creating order
    return params.require(:order).permit(:name, :email, :address, :zip_code, :credit_card, :exp_date)
  end

  def order_update_params #For order status updates
    return params.require(:order).permit(:status)
  end

  def find_order
    @order = Order.find_by(id: params[:id])
  end
end

# TODO: below this line -- Kayla's most recent version of entire controller

# def add_to_cart
#   initialize_session
#   product = Product.find_by(id: params["product_id"])
#   quantity = params["selected_quantity"].to_i
#   if product.quantity.nil? || product.quantity < 0
#     product.quantity = 0
#     product.save
#   end
#   if quantity > product.quantity.to_i
#     quantity = product.quantity #if more is added than is available, add remaining
#   end
#   #verify merchant is not buying own product
#   if !can_purchase(product)
#     redirect_to products_path
#     return
#   end
#   order = session[:order_id]? Order.find_by(id: session[:order_id]) : create_order
#   if !order.order_items.find_by(product_id:product.id).nil?
#     order_item = order.order_items.find_by(product_id:product.id)
#     if quantity <= order_item.product.quantity
#       order_item.quantity += quantity
#       # order_item.product.quantity -= quantity
#     end
#     order_item.save
#     order_item.product.save
#     flash[:status] = :success
#     flash[:result_text] = "Awesome! Your N.E.O.P.E.T.S.Y #{product.name} quantity has been updated!"
#   else
#     order_item = OrderItem.new(product_id: product.id,order_id: order.id, quantity: quantity)
#     if order_item.save
#       order.order_items << order_item
#       flash[:status] = :success
#       flash[:result_text] = "Awesome! Your N.E.O.P.E.T.S.Y #{product.name} item is in the cart!"
#     end
#   end
#   product.quantity -= quantity
#   product.save
#   redirect_to cart_path
# end
# def remove
#   order_item_id = params[:order_item].to_i
#   order_item = OrderItem.find_by(id: order_item_id)
#   order_item.product.quantity += order_item.quantity
#   order_item.product.save
#   order_item.destroy
#   redirect_to cart_path
# end
# def add_one
#   order_item_id = params[:order_item].to_i
#   order_item = OrderItem.find_by(id: order_item_id)
#   if order_item.product.quantity >= 1
#     order_item.quantity += 1
#     order_item.product.quantity -= 1
#     order_item.save
#     order_item.product.save
#   end
#   redirect_to cart_path
# end
# def less_one
#   order_item_id = params[:order_item].to_i
#   order_item = OrderItem.find_by(id: order_item_id)
#   if order_item.quantity > 1
#     order_item.quantity -= 1
#     order_item.product.quantity += 1
#     order_item.save
#     order_item.product.save
#   end
#   redirect_to cart_path
# end
# def cart_has_item(test_item)
#   session[:cart].each do |item|
#     if item["product_id"] == test_item.product_id
#       return true
#     end
#   end
#   return false
# end
# def can_purchase(product)
#   if session[:user_id] == product.merchant_id
#     flash[:status] = :failure
#     flash[:result_text] = "Merchants cannot buy their own products."
#     return false
#   end
#   true
# end
# def create_order
#   order = Order.new
#   unless order.save
#     flash[:error] = "Something went wrong: #{order.errors.messages}"
#   end
#   session[:order_id] = order.id
#   order.reload
#   return order
# end
# def update
# end
# private
# def order_items_params
#   return params.require(:order_items).permit(:product_id, :order_id, :quantity)
# end
# def initialize_session
#   return session[:cart] ||= []
# end
# end
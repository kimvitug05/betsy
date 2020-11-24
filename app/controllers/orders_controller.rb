class OrdersController < ApplicationController

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

  # def checkout
  #   redirect_to root_path
  # end


  def clear_cart
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
      flash[:status] = :success
      flash[:result_text] = "Successfully updated order ##{@order.id}"
      session[:order_id] = nil
      redirect_to order_path(@order)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update order ##{@order.id}"
      flash.now[:messages] = @order.errors.messages
      redirect_to dashboard_path
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

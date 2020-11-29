class OrdersController < ApplicationController

  def new
    @order = Order.new
  end

  def checkout
    @order = Order.find_by(id: session[:order_id])
    @cart_total = get_total
  end


  def cart
    @order = Order.find_by(id: session[:order_id])
    @cart_total = get_total
  end

  #should be in model--but...no time to refactor.
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

  def update

    @order = Order.find_by(id: session[:order_id])

    if @order.update(order_params)
      @order.status = "paid" #change status of order to paid
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

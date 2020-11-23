class OrdersController < ApplicationController

  def new
  @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.order_items = session[:cart].map { |attributes| OrderItem.new(attributes)}
    if @order.save
      flash[:status] = :success
      flash[:result_text] = "Your order has been processed. Thank you for your purchase! Your confirmation no. is ##{@order.id}"
      redirect_to order_path(@order)
    else
      flash[:status] = :failure
      flash[:result_text] = "Something went wrong. Could not create order ##{@order.id}"
      flash[:messages] = @order.errors.messages
      render :new, status: :bad_request
    end
  end

  def edit
    @order = Order.new
  end

  def update #TODO: If we want to be able to change order status
    unless @login_user
      flash[:status] = :failure
      flash[:result_text] = "Only merchants can update an order"
      render :index, status: :forbidden
      return
    end

    find_order

    if @order.update(order_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated order ##{@order.id}"
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

  def order_params
    return params.require(:order).permit(:name, :email, :address, :zip_code, :credit_card, :exp_date)
  end

  def find_order
    @order = Order.find_by(id: params[:id])
  end
end

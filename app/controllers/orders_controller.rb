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


  private

  def order_params
    return params.require(:order).permit(:name, :email, :address, :zip_code, :credit_card, :exp_date)
  end

  def find_order
    @order = Order.find_by_id(id: params[:id])
  end
end

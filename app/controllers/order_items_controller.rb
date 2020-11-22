class OrderItemsController < ApplicationController

  def create
    @order = current_order
    @order_item = OrderItem.new
    @order_item.product_id = :product_id
    @order_item.order_id = @order.id
    @order_item.quantity = :quantity
    @order_item.save
  end

    def cart
      @cart = session[:cart].map { |attributes| OrderItem.new(attributes)}
      @cart_total = get_total
    end

  def add_to_cart
    #start order array if nothing is in the cart
    initialize_session

    product = Product.find_by(id: params["product_id"])
    quantity = params["selected_quantity"].to_i

    # if product.quantity.nil?
    #   product.quantity = 0
    #   product.save
    # end

    if quantity > product.quantity.to_i
      quantity = product.quantity
    end

    order_item = OrderItem.create(product_id: product.id, quantity: quantity)

    session[:cart]  << order_item

        # flash[:status] = :success
        # flash[:result_text] = "Woohoo! Your #{product.name} is in the cart!"

    redirect_to cart_path
    return
    #start new order item
    # order_item = OrderItem.create(product_id: product.id, quantity: quantity)
    # if order_item.save
    #   session[:cart]  << order_item
    #   flash[:status] = :success
    #   flash[:result_text] = "Woohoo! Your #{product.name} is in the cart!"
    #   redirect_to cart_path
    #   return
    # else
    #   flash[:status] = :error
    #   flash[:result_text] = "There was a problem with your request"
    #   render_404
    #   return
    # end

    #Update quantity if item is already in the cart
    # @cart.each do |item|
    # if item["product_id"] == product.id && item["quantity"] < product.quantity
    #   item["quantity"] += 1
    #   flash[:status] = :success
    #   flash[:result_text] = "Woohoo! Your N.E.O.P.E.T.S.Y item is in the cart!"
    #   redirect_to cart_path
    #   return
    # elsif item["quantity"] > product.quantity
    #   flash[:status] = :error
    #   flash[:result_text] = "Oh no! Not enough inventory to fulfill your request!"
    # end
    # end
  end

  def get_total
    total = 0.0
    @cart.each do |item|
      total = total + item.product.price * item.quantity
    end
    return total
  end
  #
  # def add_quantity
  #   if session[:cart].empty?
  #   return "Oops You don't have anything in your cart! Might i suggest Green Apple Cake?"
  #
  #   if order_item["product id"] == params
  #
  #   product
  #   @order_item = OrderItem
  #
  #   @order_item.quantity += 1
  #   @order_item.save
  #   redirect_to cart_path
  # end

  # def reduce_quantity
  #   @order_item = OrderItem.find_by(session[:session_id])
  #   if @order_item.quantity > 1
  #     @order_item.quantity -= 1
  #   end
  #   @order_item.save
  #   redirect_to cart_path
  # end

  def clear_cart
    session[:cart] = []

    redirect_to cart_path
  end

  private

  def initialize_session
    return session[:cart] ||= []
  end

    def find_session_order
      @order_item = OrderItem.find_by(id: params[:id])
    end
  end

#
# product.quantity = 0
# product.save

# if quantity < product.quantity.to_i
#   quantity = product.quantity
# end

require "test_helper"

describe OrderItemsController do ##not sure how to feed database the product info into shopping cart. =S
  before do
    @merchant = merchants(:merchant1)
    @product = products(:blue_shoes)
    @order = orders(:order1)
    # @order_item = OrderItem.new(product_id: @product.id,order_id: @order.id, quantity: quantity)

  end

  it "can add a product to a cart, starting a new order item" do

    #Arrange
        @order_item_hash = {
            order_item: {
                product_id: @product.id,
                quantity: 1,
                order_id: @order.id
            },
        }

    #Act/Assert
    expect {
      post add_to_cart_path(@product), params: @order_item_hash
    }.must_change "OrderItem.count", 1

    expect(session[:order_id]).wont_be_nil
    expect(flash[:status]).must_equal :success
    expect(flash[:result_text]).must_equal "Awesome! Your N.E.O.P.E.T.S.Y #{product.name} quantity has been updated!"
    must_redirect_to cart_path

    end

  it "can empty cart" do

  end

  it "can update product quantity rather than creating new order" do

  end

  it "won't let guest purchase more products than in stock" do

  end

  it "can't add a product without enough stock" do

  end

  it "can't add to an order that's not in cart mode" do #what does this mean???

  end

  it ""

end
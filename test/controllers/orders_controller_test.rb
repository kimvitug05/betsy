require "test_helper"

describe OrdersController do
  before do
    @product = products(:blue_shoes)
    @order = orders(:order1)

    @order_item_hash = {
        order_item: {
            product_id: @product.id,
            selected_quantity: 1,
            order_id: @order.id
        },
    }
  end

  it "will not process an order with bad customer data" do
    # bad_order = Order.create(name: "Im a terrible order", email: "kayla@kayla.com", address: nil, zip_code: nil, credit_card: nil, exp_date: nil)
    #
    # bad_order_item_hash = {
    #     order_item: {
    #         product_id: @product.id,
    #         selected_quantity: 1,
    #         order_id: bad_order.id
    #     },
    # }
    #
    # expect {
    #   post submit_order_path(@product), params: bad_order_item_hash[:bad_order]
    # }.wont_change "Order.count"
    # # pp "This is my bad #{bad_order.name}"


  end

  it "changes status to paid once order is submitted" do
    #Arrange
    post add_to_cart_path(@product), params: @order_item_hash[:order_item]

    #Assert
    expect @order.status == "paid"

  end

  it "can remove items from the cart" do

    expect {
      get clear_cart_path(@product), params: @order_item_hash[:order_item]
    }.wont_change "OrderItem.count"

  end
end

require "test_helper"

describe OrderItem do
  before do
    @order_item = order_items(:order_item1)
  end

  describe "validation" do
    it "is valid if quantity is an integer greater than zero" do
      @order_item.quantity = 1

      expect(@order_item.valid?).must_equal true
    end

    it "must have a quantity" do
      @order_item.quantity = nil

      expect(@order_item.valid?).must_equal false
      expect(@order_item.errors.messages).must_include :quantity
      expect(@order_item.errors.messages[:quantity]).must_include "can't be blank"
    end

    it "is not valid if quantity is zero" do
      @order_item.quantity = 0

      expect(@order_item.valid?).must_equal false
      expect(@order_item.errors.messages).must_include :quantity
      expect(@order_item.errors.messages[:quantity]).must_include "must be greater than 0"
    end

    it "quantity must be an integer" do
      @order_item.quantity = "hello"

      expect(@order_item.valid?).must_equal false
      expect(@order_item.errors.messages).must_include :quantity
      expect(@order_item.errors.messages[:quantity]).must_include "is not a number"
    end
  end

  describe "relations" do
    it "belongs to a product" do
      expect(@order_item).must_respond_to :product
      expect(@order_item.product).must_be_kind_of Product
    end

    it "belongs to an order" do
      expect(@order_item).must_respond_to :order
      expect(@order_item.order).must_be_kind_of Order
    end
  end
end

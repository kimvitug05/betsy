require "test_helper"

describe Order do
  before do
    @order = orders(:order2)
  end

  describe "validation" do
    it "is valid when all fields are filled" do
      expect(@order.valid?).must_equal true
    end

    it "is invalid without a name" do
      @order.name = nil
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages.include?(:name)).must_equal true
      expect(@order.errors.messages[:name].include?("can't be blank")).must_equal true
    end

    it "is invalid without an address" do
      @order.address = nil
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages.include?(:address)).must_equal true
      expect(@order.errors.messages[:address].include?("can't be blank")).must_equal true
    end

    it "is invalid without an e-mail" do
      @order.email = nil
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages.include?(:email)).must_equal true
      expect(@order.errors.messages[:email].include?("can't be blank")).must_equal true
    end

    it "email is invalid without @ symbol" do
      @order.email = "dfadfasfa"
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages.include?(:email)).must_equal true
      expect(@order.errors.messages[:email].include?("is invalid")).must_equal true
    end

    it "credit card is invalid if length != 16" do
      @order.credit_card = "123342"
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages.include?(:credit_card)).must_equal true
      expect(@order.errors.messages[:credit_card].include?("is too short (minimum is 16 characters)")).must_equal true
    end

    it "not valid if credit card does not exist" do
      @order.credit_card = nil
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages.include?(:credit_card)).must_equal true
      expect(@order.errors.messages[:credit_card].include?("can't be blank")).must_equal true
    end

    it "not valid if exp_date does not exist" do
      @order.exp_date = nil
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages.include?(:exp_date)).must_equal true
      expect(@order.errors.messages[:exp_date].include?("can't be blank")).must_equal true
    end

    it "not valid if zip code does not exist" do
      @order.zip_code = nil
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages.include?(:zip_code)).must_equal true
      expect(@order.errors.messages[:zip_code].include?("can't be blank")).must_equal true
    end
  end

  describe "relations" do
    it "has many order items" do
      order = orders(:order1)

      assert_operator order.order_items.count, :>, 1

      order.order_items.each do |order_items|
        expect(order_items).must_be_instance_of OrderItem
      end
    end

    it "has many products through order items" do
      order = orders(:order1)

      assert_operator order.products.count, :>, 1

      order.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
  end

  describe "custom methods" do
    it "can calculate the order total" do
    end

    it "can grab the last 4 of a credit card number" do
    end

    it "can calculate the total cost of a particular order item" do
    end
  end
end

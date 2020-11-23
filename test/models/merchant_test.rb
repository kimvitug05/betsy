require "test_helper"

describe Merchant do
  before do
    @merchant = merchants(:merchant2)
  end

  describe "validations" do
    it "is valid when all fields are filled" do
      result = @merchant.valid?
      expect(result).must_equal true
    end

    it "is invalid without a username" do
      @merchant.username = nil
      expect(@merchant.valid?).must_equal false
      expect(@merchant.errors.messages.include?(:username)).must_equal true
      expect(@merchant.errors.messages[:username].include?("can't be blank")).must_equal true
    end

    it "is invalid without an e-mail" do
      @merchant.email = nil
      expect(@merchant.valid?).must_equal false
      expect(@merchant.errors.messages.include?(:email)).must_equal true
      expect(@merchant.errors.messages[:email].include?("can't be blank")).must_equal true
    end

    it "is invalid if email is improperly formatted" do
      @merchant.email = "iamanemail.com"
      expect(@merchant.valid?).must_equal false
      expect(@merchant.errors.messages.include?(:email)).must_equal true
      expect(@merchant.errors.messages[:email].include?("is invalid")).must_equal true
    end

    it "fails validation when the username already exists" do
      new_merchant = Merchant.create(username: @merchant.username, email: "im_good@email.com")

      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages.include?(:username)).must_equal true
      expect(new_merchant.errors.messages[:username].include?("has already been taken")).must_equal true
    end

    it "fails validation when the email already another_merchant" do
      another_merchant = Merchant.create(username: "neopet_2020", email: @merchant.email)

      expect(another_merchant.valid?).must_equal false
      expect(another_merchant.errors.messages.include?(:email)).must_equal true
      expect(another_merchant.errors.messages[:email].include?("has already been taken")).must_equal true
    end

    it "requires a unique uid" do
      dup = Merchant.new(username: "bob_belcher", provider: "github", uid: 12345, email: "bob@bob.com")
      expect(dup.valid?).must_equal false
      expect(dup.errors.messages).must_include :uid
      expect(dup.errors.messages[:uid]).must_equal ["has already been taken"]
    end
  end

  describe "relations" do
    it "has a list of products" do
      expect(@merchant).must_respond_to :products

      @merchant.products.each do |product|
        expect(product).must_be_kind_of Product
      end
    end
  end

  describe "custom methods" do
    it "can calculate the total revenue by status" do
      merchant = merchants(:merchant1)

      expect(merchant.total_revenue_by_status("pending")).must_be_close_to 1010.27
      expect(merchant.total_revenue_by_status("paid")).must_equal 0
      expect(merchant.total_revenue_by_status("complete")).must_equal 0
      expect(merchant.total_revenue_by_status("cancelled")).must_equal 0
    end
  end
end

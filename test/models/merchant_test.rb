require "test_helper"

describe Merchant do
  before do
    @merchant1 = merchants(:merchant1)
  end

  describe "instantiation" do
    it "will have the required fields" do
      skip
    end
  end

  describe "validations" do
    it "is valid if username is present" do
      merchant = Merchant.new(username: "linda_belcher", email: "linda@linda.com", uid: "23456")
      expect(merchant.valid?).must_equal true
    end

    it "is invalid if username is nil" do
      merchant = Merchant.new(username: nil)
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :username
    end

    it "is valid if email is present" do
      merchant = Merchant.new(username: "linda_belcher", email: "linda@linda.com", uid: "23456")
      expect(merchant.valid?).must_equal true
    end

    it "is invalid if email is nil" do
      merchant = Merchant.new(email: nil)
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :email
    end

    #TODO - edge case for uid
    it "requires a unique uid" do
      dup = Merchant.new(username: "bob_belcher", provider: "github", uid: 12345, email: "bob@bob.com")
      expect(dup.valid?).must_equal false
      expect(dup.errors.messages).must_include :uid
    end
  end

  describe "relations" do
    it "has a list of products" do
      expect(@merchant1).must_respond_to :products

      #TODO - uncomment when products are created

      # @merchant1.products.each do |product|
      #   expect(product).must_be_kind_of Product
      # end
    end
  end
end

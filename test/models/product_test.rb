require "test_helper"

describe Product do
  describe 'validations' do
    before do
      merchant_id = Merchant.new(username:"123", email:"abc", id: 5)
      @product = Product.create(name: "Shoyru", price: 5.00, merchant_id: merchant_id[:id], quantity: 500, category_id: 1)
    end

      it "is valid when all fields are filled" do

        result = @product.valid?
        p @product
       expect(result).must_equal true
      end
  end
end
# "username"
# t.string "email"
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.string "uid"
# t.string "provider"
# t.string "avatar"

# t.string "name"
# t.float "price"
# t.integer "merchant_id"
# t.integer "quantity"
# t.integer "category_id"
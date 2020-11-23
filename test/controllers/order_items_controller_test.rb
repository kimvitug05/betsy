require "test_helper"

describe OrderItemsController do
    let(:merchant) {Merchant.create(username: "Bob Belcher", email: "bob@bob.com", uid: "12345")}
    let(:product) {Product.create(name: "desktop computer", price: 150.57, merchant_id: 1, quantity: 13)}
    let(:order) {OrderItem.create(product_id: product.id, quantity: 5)}
    before do
      @merchant = merchants(:merchant1)
    end
    create_table "order_items", force: :cascade do |t|
      t.integer "product_id"
      t.integer "order_id"
      t.integer "quantity"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "status", default: "pending"
    end



  end
  describe "add item to cart" do

  end
end

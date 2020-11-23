require "test_helper"

describe ProductsController do
  let (:product) { products(:blue_shoes) }
  before do
    @merchant = Merchant.create!(email: "email@123.com", username: "username", uid: "123456", provider: "github", avatar: "avatar")

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(@merchant))

    get auth_callback_path(:github)

    @product = Product.create!(
      name: "sleds",
      price: 2.99,
      merchant_id: @merchant.id,
      quantity: 10,
      active: true)
  end

  describe "index" do
    it "should get index" do
      get products_path

      must_respond_with :success
    end

    it "should get index when there are no products" do
      Product.all do |product|
        product.destroy
      end

      get products_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "should get the product show page" do
      get product_path(products(:laptop))

      must_respond_with :success
    end

    it "should redirect if the product does not exist" do
      get product_path(-1)

      must_respond_with :redirect
      must_redirect_to products_path
    end
  end

  describe "new" do
    it "succeeds" do
      get new_product_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a product with valid data" do

      new_product = { product: {name: "Shoes", price: 2.99, merchant_id: @merchant[:id], quantity: 10 }}

      expect {
        post "/products", params: new_product
      }.must_change "Product.count", 1

      new_product_id = Product.find_by(name: "Shoes").id

      must_respond_with :redirect
      must_redirect_to product_path(new_product_id)
    end

    it "renders bad_request and does not update the DB for invalid data" do
      bad_product = { product: { name: "Shoes", price: nil, merchant_id: @merchant[:id], quantity: 10 } }

      expect {
        post products_path, params: bad_product
      }.wont_change "Product.count"

      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "succeeds in editing existing product" do
      get edit_product_path(@product[:id])

      must_respond_with :success
    end

    it "should redirect if the product does not exist" do
      get edit_product_path(-1)

      must_respond_with :redirect
      must_redirect_to products_path
    end
  end

  describe "update" do
    it "succeeds for updating" do
      updates = { product: { name: "fries" } }

      expect {
        put product_path(@product), params: updates
      }.wont_change "Product.count"

      updated_product = Product.find_by(id: @product.id)

      expect(updated_product.name).must_equal "fries"
      must_respond_with :redirect
      must_redirect_to product_path(@product.id)
    end

    it "responds with bad request if updated product is invalid" do
      updates = { product: { name: nil } }

      expect {
        put product_path(@product), params: updates
      }.wont_change "Product.count"

      must_respond_with :bad_request
    end

    it "should redirect if the product does not exist" do
      put product_path(-1)

      must_respond_with :redirect
      must_redirect_to products_path
    end
  end
end

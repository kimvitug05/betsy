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

  describe "show" do
    # used fixture
    it "shows a product" do
      # product = products(:blue_shoes)
      get products_path(@product.id)

      must_respond_with :success
    end

    it "renders 404 not_found for a invalid product ID" do
      # product = products(:blue_shoes)
      # destroyed_id = product.id
      # product.destroy

      get product_path(-99)

      must_respond_with :not_found
    end
  end

  describe "edit" do
    it "succeeds in editing existing product" do
      get edit_product_path(@product[:id])

      must_respond_with :success
    end

    it "renders 404 not_found for an invalid product ID" do
      get edit_product_path(-99)
      must_respond_with :not_found
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

    # it "renders bad_request for invalid data" do
    #   product = { product: { name: "Shoes", price: 3.99, merchant_id: 1, quantity: 10, category_id: 1 } }

    #   expect {
    #     put product_path(product), params: product
    #   }.wont_change "Product.count"

    #   bad_product = Product.find_by(id: product.id)

    #   must_respond_with :not_found
    # end

    # it "renders 404 not_found for a invalid product ID" do


    #   put product_path(-99), params: { product: { name: "Test" } }

    #   must_respond_with :not_found
    # end
  end
end

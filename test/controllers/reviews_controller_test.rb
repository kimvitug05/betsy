require "test_helper"

describe ReviewsController do
  before do
    @merchant = Merchant.create!(email: "email@123.com", username: "username", uid: "123456", provider: "github", avatar: "avatar")

    @product = Product.create!(
        name: "sleds",
        price: 2.99,
        merchant_id: @merchant.id,
        quantity: 10,
        active: true)
  end

  describe "new" do
    it "new review with product id" do
      get new_product_review_path(@product.id)

      must_respond_with :success
    end

    it "should redirect to products page if the product does not exist" do
      get review_path(-1)

      must_respond_with :redirect
      must_redirect_to products_path
    end
  end

  describe "create" do
    it "creates a review with valid data" do

      new_review = {review: {rating: 5, description: "meh", product_id: @product[:id]}}

      expect {
        post "/products/#{@product.id}/reviews", params: new_review
      }.must_change "Review.count", 1

      # new_review_id = Review.find_by(description: "meh").id

      must_respond_with :redirect
      must_redirect_to product_path(@product.id)
    end

    it "renders bad_request and does not update the DB for invalid data" do
      bad_review = {review: {rating: nil, description: nil, product_id: @product[:id]}}

      expect {
        post "/products/#{@product.id}/reviews", params: bad_review
      }.wont_change "Review.count"

      must_respond_with :bad_request
    end

    it "renders bad_request and does not update the DB if merchant tries to review their own product" do
      perform_login(@product.merchant)
      bad_review = {review: {rating: nil, description: nil, product_id: @product[:id]}}

      expect {
        post "/products/#{@product.id}/reviews", params: bad_review
      }.wont_change "Review.count"

      must_respond_with :redirect
      must_redirect_to dashboard_path
    end
  end
end

class ReviewsController < ApplicationController
  def index
    if params[:id]
      product = Product.find_by(id: params[:id])
      @reviews = product.reviews
    else
      @reviews = Review.all
    end

    def show
      if @review.nil?
        redirect_to products_path
        return
      end
    end

    def new
      @review = Review.new
      @quantity = @product.quantity
    end

    private

    def review_params
      return params.require(:review).permit(:product_id, :rating)
    end
  end

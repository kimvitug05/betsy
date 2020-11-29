class ReviewsController < ApplicationController
  before_action :find_product

  def new
    @review = @product.reviews.new
  end

  def create
    @review = Review.new(review_params)

    if @review.nil?
      flash[:status] = :failure
      flash[:result_text] = "Could not review #{@product}"
      render :new, status: :bad_request
    end

    if @login_user
      if @product.merchant_id == @login_user.id
        flash[:status] = :failure
        flash[:result_text] = "Cannot review your own product!"
        redirect_to dashboard_path
        return
      end
    end

    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Successfully reviewed product: #{@product.name}"
      redirect_to product_path(@product.id)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not review #{@product}"
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  private

  def find_product
    @product = Product.find_by(id: params[:product_id])
    if @product.nil?
      flash.now[:status] = :failure
      flash.now[:result_text] = "Something went wrong. Could not find product."
      redirect_to products_path
    end
  end

  def review_params
    return params.require(:review).permit(:rating, :description, :review_id).with_defaults(product_id: @product.id)
  end
end
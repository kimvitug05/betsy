class ReviewsController < ApplicationController
  before_action :find_product
  #, only: [:index, :new, :create]

  def index
    if params[:product_id]
      product = Product.find_by(id: params[:product_id])
      @reviews = product.reviews
    else
      @reviews = Review.all
    end
    end

    def show
      if @review.nil?
        redirect_to products_path
        return
      end
    end

    def new
      if params[:product_id]
        product = Product.find_by(id: params[:product_id])
        @review = product.reviews.new
      else
        @review = Review.new
      end
    end

    def create
      @review = Review.new(review_params)

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
      @product = Product.find_by_id(params[:product_id])
    end

    def review_params
      return params.require(:review).permit(:rating, :description).with_defaults(product_id: @product.id)
    end
  end
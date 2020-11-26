require "test_helper"

describe Review do
  describe "custom methods" do
    it "calculate 2 empty stars if rating is 3" do
      @review = Review.new(rating: 3)

      expect(@review.calculate_empty_stars).must_equal 2
    end

    it "calculate no empty stars if rating is 5" do
      @review = Review.new(rating: 5)

      expect(@review.calculate_empty_stars).must_equal 0
    end
  end

  describe "validation" do
    before do
      @product = products(:laptop)
      @review = Review.new(rating: 5, product_id: @product.id)
    end

    it "is valid when all fields are filled" do
      expect(@review.valid?).must_equal true
    end

    it "is invalid without a rating" do
      @review.rating = nil

      expect(@review.valid?).must_equal false
      expect(@review.errors.messages.include?(:rating)).must_equal true
      expect(@review.errors.messages[:rating].include?("can't be blank")).must_equal true
      expect(@review.errors.messages[:rating].include?("is not a number")).must_equal true
    end

    it "is invalid with rating less than 1" do
      @review.rating = 0

      expect(@review.valid?).must_equal false
      expect(@review.errors.messages.include?(:rating)).must_equal true
      expect(@review.errors.messages[:rating].include?("must be between 1 and 5 inclusive")).must_equal true
    end

    it "is invalid with rating greater than 5" do
      @review.rating = 6

      expect(@review.valid?).must_equal false
      expect(@review.errors.messages.include?(:rating)).must_equal true
      expect(@review.errors.messages[:rating].include?("must be between 1 and 5 inclusive")).must_equal true
    end

    it "is invalid with non-integer rating" do
      @review.rating = 3.14

      expect(@review.valid?).must_equal false
      expect(@review.errors.messages.include?(:rating)).must_equal true
      expect(@review.errors.messages[:rating].include?("must be an integer")).must_equal true
    end
  end

  describe "relationships" do
    it "review belongs to product" do
      @review = Review.new(rating: 5)
      @review.product = products(:laptop)

      @review.save
      @review = Review.find_by(id: @review.id)

      expect(@review.product).must_equal products(:laptop)
    end
  end
end

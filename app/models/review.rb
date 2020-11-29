class Review < ApplicationRecord
  belongs_to :product

  validates :rating, presence: true, numericality: { only_integer: true }, inclusion: { in: 1..5, message: 'must be between 1 and 5 inclusive' }

  def calculate_empty_stars
    return (5 - self.rating)
  end
end

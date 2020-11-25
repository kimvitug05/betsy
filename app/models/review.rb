class Review < ApplicationRecord
  belongs_to :product

  validates :rating, presence: true, numericality: { only_integer: true, in: 1..5 }

  def calculate_empty_stars
    return (5 - self.rating)
  end

end

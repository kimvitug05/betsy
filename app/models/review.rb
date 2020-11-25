class Review < ApplicationRecord
  belongs_to :product

  validates :rating, presence: true, numericality: { only_integer: true, in: 1..5 }



end

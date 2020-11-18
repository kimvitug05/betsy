class Review < ApplicationRecord
  validates :rating, presence: true, numericality: { only_integer: true, in: 1..5 }
end

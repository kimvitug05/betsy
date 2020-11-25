class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_and_belongs_to_many :categorizations
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  def average_rating
    ratings = self.reviews.map { |review| review[:rating] }

    ratings.compact!

    if ratings.length == 0
      mean = 0
    else
      mean = (ratings.sum.to_f) / (ratings.length)
    end

    return mean
  end

  def calculate_empty_stars
    return (5 - self.average_rating.round)
  end

  def self.spotlight
    return self.order('RANDOM()').limit(4)
  end
end

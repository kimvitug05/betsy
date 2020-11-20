class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_many :categorizations
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }


end

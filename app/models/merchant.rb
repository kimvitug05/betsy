class Merchant < ApplicationRecord
  has_many :products

  validates :username, uniqueness: true, presence: true
  validates :email, presence: true, format: {with: /@/}, uniqueness: true
end

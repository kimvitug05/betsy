class Merchant < ApplicationRecord
  validates :username, uniqueness: true, presence: true
  validates :email, presence: true, format: {with: /@/}, uniqueness: true
end

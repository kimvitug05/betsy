class Merchant < ApplicationRecord
  has_many :products

  validates :username, uniqueness: true, presence: true
  validates :email, presence: true, format: {with: /@/}, uniqueness: true

  def self.build_from_github(auth_hash)
    user = Merchant.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.username = auth_hash["info"]["name"]
    user.email = auth_hash["info"]["email"]
    # Note that the user has not been saved.
    # We'll choose to do the saving outside of this method
    return user
  end
end

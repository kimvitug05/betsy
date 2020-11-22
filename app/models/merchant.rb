class Merchant < ApplicationRecord
  has_many :products

  validates :username, uniqueness: true, presence: true
  validates :email, presence: true, format: {with: /@/}, uniqueness: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]
    merchant.avatar = auth_hash["info"]["image"]
    # Note that the user has not been saved.
    # We'll choose to do the saving outside of this method
    return merchant
  end

  def total_revenue
    return 0 if self.products.empty?
    result = 0

    self.products.sum do |product|
      product.order_items.each do |order_item|
        result += order_item.quantity * product.price
      end
    end

    return result
  end

  def total_revenue_by_status(status)
    return 0 if self.products.empty?
    result = 0

    self.products.each do |product|
      product.order_items.each do |order_item|
        if order_item.order.status == status
          result += order_item.quantity * product.price
        end
      end
    end

    return result
  end

  #TODO is this a quantity or a list of orders?

  def total_num_orders_by_status(status)
    return 0 if self.products.empty?
    result = []

    self.products.each do |product|
      product.order_items.each do |order_item|
        if order_item.order.status == status
          result << order_item.order_id
        end
      end
    end

    return result.uniq.length
  end

  def filter_orders(status)
    return 0 if self.products.empty?
    result = []

    self.products.each do |product|
      product.order_items.each do |order_item|
        if order_item.order.status == status
          result << order_item.order
        end
      end
    end

    return result.uniq
  end

  def order_total(order)
    sum = 0
    order.order_items.each do |order_item|
      sum += order_item.product.price
    end
    return sum
  end
end


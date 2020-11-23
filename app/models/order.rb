class Order < ApplicationRecord
  #TODO validations?

  has_many :order_items
  has_many :products, through: :order_items

  def order_total(merchant_id = nil)
    if merchant_id
      sum = 0
      self.order_items.each do |order_item|
        if order_item.product.merchant_id == merchant_id
          sum += order_item.product.price
        end
      end
      return sum
    else
      sum = 0
      self.order_items.each do |order_item|
        sum += order_item.product.price
      end
      return sum
    end
  end

  def credit_card_end(card_num)
    return card_num.split(//).last(4).join
  end
end

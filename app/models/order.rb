class Order < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :email, presence: true, format: {with: /@/}
  validates :credit_card, presence: true, length: {minimum: 16, maximum: 16}
  validates :exp_date, presence: true
  validates :zip_code, presence: true

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  def order_total(merchant_id = nil)
    sum = 0
    if merchant_id
      self.extract_merchant_order_items(merchant_id).each do |order_item|
        sum += order_item.product.price * order_item.quantity
      end
      return sum

    else
      self.order_items.each do |order_item|
        sum += order_item.product.price * order_item.quantity
      end
      return sum
    end
  end

  def credit_card_end(card_num)
    return card_num.split(//).last(4).join
  end

  def extract_merchant_order_items(merchant_id)
    output_array = []
    self.order_items.each do |order_item|
      if order_item.product.merchant_id == merchant_id
        output_array << order_item
      end
    end
    return output_array
  end

  # def extract_merchant_order_items(merchant_id)
  #   hash = Hash.new(0)
  #   self.order_items.each do |order_item|
  #     if order_item.product.merchant_id == merchant_id
  #       hash[order_item.id] = order_item
  #     end
  #   end
  #   return hash
  # end

  def order_item_total_cost(order_item_id)
    order_item = OrderItem.find_by(id: order_item_id)
    return (order_item.product.price * order_item.quantity)
  end

end

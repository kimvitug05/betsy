class Categorization < ApplicationRecord
  has_and_belongs_to_many :products
  validates :name, presence: true, uniqueness: true

  def self.print_categories
    output = []

    Categorization.all.each do |category|
      output << category
    end

    return output
  end
end

class CreateCategorizationsProductsJoin < ActiveRecord::Migration[6.0]
  def change
    create_table :categorizations_products do |t|
      t.belongs_to :product, index: true
      t.belongs_to :categorization, index: true
    end
  end
end

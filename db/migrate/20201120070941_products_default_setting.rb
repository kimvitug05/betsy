class ProductsDefaultSetting < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :status, :boolean, :default => true
  end
end

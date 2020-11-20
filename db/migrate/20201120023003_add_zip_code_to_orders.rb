class AddZipCodeToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :zip_code, :string
  end
end

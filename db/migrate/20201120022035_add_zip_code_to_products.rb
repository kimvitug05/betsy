class AddZipCodeToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :zip, :string
  end
end

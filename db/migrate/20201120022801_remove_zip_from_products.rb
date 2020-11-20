class RemoveZipFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :zip, :string
  end
end

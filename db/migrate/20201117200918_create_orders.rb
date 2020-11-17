class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :address
      t.string :name
      t.string :status
      t.string :email
      t.string :credit_card
      t.string :exp_date

      t.timestamps
    end
  end
end

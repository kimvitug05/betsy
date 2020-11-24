class AddDescriptionToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :description, :string
  end
end

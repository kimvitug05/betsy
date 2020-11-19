class AddUidAndProviderToMerchants < ActiveRecord::Migration[6.0]
  def change
    add_column :merchants, :uid, :string
    add_column :merchants, :provider, :string
    add_column :merchants, :avatar, :string
  end
end

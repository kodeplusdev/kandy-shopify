class AddKandyToShops < ActiveRecord::Migration
  def change
    add_column :shops, :kandy_api_key, :string
    add_column :shops, :kandy_api_secret, :string
    add_column :shops, :kandy_username, :string
    add_column :shops, :kandy_access_token, :string
  end
end

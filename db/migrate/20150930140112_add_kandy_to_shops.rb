class AddKandyToShops < ActiveRecord::Migration
  def change
    add_column :shops, :kandy_api_key, :string
    add_column :shops, :kandy_api_secret, :string
  end
end

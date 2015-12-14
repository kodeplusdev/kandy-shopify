class AddKandyToShops < ActiveRecord::Migration
  def change
    add_column :shops, :kandy_api_key, :string
    add_column :shops, :kandy_api_secret, :string
    add_column :shops, :kandy_user_guest_id, :integer
  end
end

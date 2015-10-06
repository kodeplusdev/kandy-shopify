class AddKandyToShops < ActiveRecord::Migration
  def change
    add_column :shops, :kandy_api_key, :string
    add_column :shops, :kandy_api_secret, :string
    add_column :shops, :kandy_phone_number, :string
    add_column :shops, :kandy_username, :string
    add_column :shops, :kandy_token, :string

    add_column :shops, :sms_order_template, :string
  end
end

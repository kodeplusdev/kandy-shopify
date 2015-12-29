class AddDetailsToShops < ActiveRecord::Migration
  def change
    add_column :shops, :email, :string
    add_column :shops, :phone, :string
    add_column :shops, :time_zone, :string
  end
end

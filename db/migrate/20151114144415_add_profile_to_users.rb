class AddProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :full_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :avatar, :string
  end
end

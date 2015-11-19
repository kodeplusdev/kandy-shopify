class AddShopToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :shop, index: true, foreign_key: true
  end
end

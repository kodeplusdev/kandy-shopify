class AddInitializedToShops < ActiveRecord::Migration
  def change
    add_column :shops, :initialized, :boolean, default: false
  end
end

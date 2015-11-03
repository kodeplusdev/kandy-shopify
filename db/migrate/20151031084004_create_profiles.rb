class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

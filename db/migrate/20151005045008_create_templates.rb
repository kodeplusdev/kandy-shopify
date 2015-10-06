class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :order_creation
      t.string :order_update
      t.string :order_payment
      t.string :customer_creation
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

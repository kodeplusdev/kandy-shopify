class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :name, null: false
      t.boolean :enabled, default: true
      t.string :color, default: '#000000'
      t.text :json_string
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

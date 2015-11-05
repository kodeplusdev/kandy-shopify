class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :name, null: false
      t.boolean :enabled, default: true
      t.string :color, null: false, default: '#000000'
      t.string :json_string, null: false
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

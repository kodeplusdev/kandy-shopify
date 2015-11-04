class CreateChatWidgets < ActiveRecord::Migration
  def change
    create_table :chat_widgets do |t|
      t.string :name
      t.boolean :enabled
      t.string :color
      t.string :json_string
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

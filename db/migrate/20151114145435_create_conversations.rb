class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :name
      t.string :status, default: 'open'
      t.text :messages, default: '[]'
      t.integer :rating, default: 0
      t.references :shop, index: true, foreign_key: true
      t.references :visitor, index: true, foreign_key: true

      t.timestamps null: false
    end

    create_table :conversations_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :conversation, index: true, foreign_key: true
    end
  end
end

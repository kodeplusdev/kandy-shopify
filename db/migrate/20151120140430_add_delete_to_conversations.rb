class AddDeleteToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :deleted, :boolean, default: false
    add_column :conversations, :archived, :boolean, default: false
  end
end

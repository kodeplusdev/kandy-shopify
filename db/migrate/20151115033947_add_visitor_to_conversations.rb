class AddVisitorToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :email, :string
    add_column :conversations, :location, :text, default: '{}'
  end
end

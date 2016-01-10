class AddKandyUserToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :full_user_id, :string
    add_column :conversations, :user_password, :string
    add_column :conversations, :user_name, :string
    add_column :conversations, :user_access_token, :string
  end
end

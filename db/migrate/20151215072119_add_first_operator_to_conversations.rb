class AddFirstOperatorToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :first_operator_id, :integer
  end
end

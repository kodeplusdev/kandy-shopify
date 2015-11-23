if @conversation
  json.(@conversation, :id, :title, :name, :email, :status, :rating, :messages, :location, :created_at)
  json.histories @shop.conversations.history(@conversation.email, @conversation.location['ip']), :created_at
  json.operators @conversation.users, :id, :email, :full_name, :display_name, :avatar, :role
end
json.online @shop.users.online.size > 0
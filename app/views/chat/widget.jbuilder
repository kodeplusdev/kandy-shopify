if @conversation
  json.(@conversation, :id, :name, :status, :rating, :messages, :location, :created_at)
  json.operators @conversation.users, :id, :email, :full_name, :display_name, :avatar, :role
end
json.online @shop.users.online.size > 0

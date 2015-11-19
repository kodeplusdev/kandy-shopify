if @conversation
  json.(@conversation, :id, :name, :status, :rating, :messages, :location, :created_at)
  json.operators @conversation.users, :id, :email, :full_name, :display_name, :avatar, :role
end
json.available @shop.users.available.size > 0
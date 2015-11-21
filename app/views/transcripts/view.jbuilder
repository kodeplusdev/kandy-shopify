if @conversation
  json.(@conversation, :id, :title, :name, :email, :status, :rating, :messages, :location, :created_at)
  json.operators @conversation.users, :id
end
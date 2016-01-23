if @conversation
  json.(@conversation, :id, :name, :email, :title, :user_name, :user_password, :full_user_id, :user_access_token , :status, :rating, :messages, :created_at)
  json.histories @shop.conversations.history(@conversation.email, @conversation.location['ip']), :id, :created_at
  json.operators []
end
json.online @shop.users.online.size > 0
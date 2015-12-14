json.chatData do
  if @conversation
    json.(@conversation, :id, :name, :title, :status, :rating, :messages, :created_at)
    json.operators @conversation.users do |u|
      json.username u.kandy_user.kandy_username
      json.(u, :id, :display_name, :avatar, :role)
    end
  end
  json.online @shop.users.online.size > 0
end
json.operators @shop.users do |u|
  json.username u.kandy_user.kandy_username
end
json.chatData do
  if @conversation
    json.(@conversation, :id, :name, :title, :user_name, :user_password, :full_user_id, :user_access_token , :status, :rating, :messages, :created_at)
    json.operators @conversation.users do |u|
      json.username u.kandy_user.kandy_username
      json.(u, :id, :display_name, :avatar, :role)
    end
  end
  json.online @shop.users.online.size > 0
end
json.operators @shop.users do |u|
  unless u.kandy_user.blank?
    json.username u.kandy_user.kandy_username
  end
end
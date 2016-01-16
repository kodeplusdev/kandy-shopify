json.me do
  json.(current_user, :id, :email, :display_name, :role, :status, :avatar)
  json.kandy_username current_user.kandy_user.kandy_username
end
json.shop do
  json.id @shop.id
  json.host root_url
  json.widget do
    json.joined_chat @shop.widget.json_string['in_chat']['joined_chat']
    json.left_chat @shop.widget.json_string['in_chat']['left_chat']
    json.closed_chat @shop.widget.json_string['in_chat']['closed_chat']
  end
end
json.conversations @conversations do |conversation|
  json.(conversation, :id, :name, :email, :title, :user_name, :user_password, :full_user_id, :user_access_token , :status, :rating, :messages, :location, :created_at)
  json.histories @shop.conversations.history(conversation.email, conversation.location['ip']), :id, :created_at
  json.operators conversation.users do |u|
    json.id u.id
    json.kandy_username u.kandy_user.kandy_username
  end
end
json.users @users do |user|
  unless user.kandy_user.blank?
    json.kandy_username user.kandy_user.kandy_username
    json.(user, :id, :display_name, :role, :avatar)
    json.online user.online?
  end
end
json.me do
  json.(current_user, :id, :email, :full_name, :display_name,:phone_number, :role, :status, :avatar)
  json.conversations current_user.conversations, :id
end
json.shop do
  json.id @shop.id
  json.host root_url
  json.operator_username @shop.kandy_username
  json.operator_password @shop.kandy_password
  json.guest_username @shop.kandy_username_guest
  json.widget do
    json.(@shop.widget, :id, :name, :enabled, :color)
    json.json @shop.widget.json_string
  end
end
json.conversations @conversations do |conversation|
  json.(conversation, :id, :title, :name, :email, :status, :rating, :messages, :location, :created_at)
  json.histories @shop.conversations.history(conversation.email, conversation.location['ip']), :created_at
  json.operators conversation.users, :id
end
json.users @users do |user|
  json.(user, :id, :email, :full_name, :display_name, :role, :avatar)
  json.conversations user.conversations.size
end
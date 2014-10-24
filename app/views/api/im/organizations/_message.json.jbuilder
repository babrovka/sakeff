# Renders a message in api format
json.id message.id
json.text message.text
json.created_at message.created_at
json.sender_user do
  json.partial! 'api/users/user', user: message.sender_user
end

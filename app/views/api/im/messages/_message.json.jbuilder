# Renders a message in api format
json.id message.id
json.text message.text
json.sender do
  json.partial! 'sender', sender: message.sender_user
end
json.created_at message.created_at
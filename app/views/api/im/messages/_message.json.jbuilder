# Renders a message in api format
json.id message.id
json.text message.text
json.sender do
  json.id message.sender.id
  json.username message.sender.username
  json.first_name message.sender.first_name
  json.last_name message.sender.last_name
  json.avatar_url UserDecorator.decorate(message.sender).image_path
  json.title message.sender.title
end
json.created_at message.created_at
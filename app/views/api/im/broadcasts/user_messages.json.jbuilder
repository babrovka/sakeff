# Renders all user messages in json
json.array!(@messages) do |message|
  json.partial! 'message', message: message
end
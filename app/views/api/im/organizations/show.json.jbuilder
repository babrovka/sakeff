# Renders all dialogue messages in json
json.organization_messages do
  json.array!(@messages) do |message|
    json.partial! 'message', message: message
  end
end
# Renders all dialogue messages in json
json.broadcast do
  json.array!(@messages) do |message|
    json.partial! 'message', message: message
  end
end
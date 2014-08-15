json.id sender.id
json.username sender.username
json.first_name sender.first_name
json.last_name sender.last_name
json.avatar_url UserDecorator.decorate(sender).image_path
json.title sender.title
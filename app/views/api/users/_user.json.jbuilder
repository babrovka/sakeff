json.id user.id
json.username user.username
json.first_name user.first_name
json.last_name user.last_name
json.avatar_url UserDecorator.decorate(user).image_path
json.title user.title
json.organization do
  json.partial! 'api/organizations/organization', organization: user.organization
end
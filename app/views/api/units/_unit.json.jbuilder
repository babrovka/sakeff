# Renders a unit in json format
# @note is called on api/units/index.json.jbuilder
json.id unit.id
json.parent unit.parent.try(:id) || '#'
json.text unit.label
json.model_filename unit.model_filename
json.created_at unit.created_at

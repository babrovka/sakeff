# Renders a unit in json format
# @note is called on api/units/index.json.jbuilder
json.id unit.id.upcase
json.parent h_unit_parent(unit)
json.text unit.label
json.model_filename unit.model_filename
json.created_at unit.created_at
json.is_favourite h_unit_is_favourite?(unit)

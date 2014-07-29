# Renders a unit in json format
# @note is called on api/units/index.json.jbuilder
json.id unit.id
json.text unit.label
json.children unit.has_children > 0
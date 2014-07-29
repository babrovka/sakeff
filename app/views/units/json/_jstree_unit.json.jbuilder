# Renders a unit in json format
# @note is called on superuser/units view for a jstree
json.id unit.id
json.text unit.label
json.children unit.has_children > 0
# Renders a unit bubble in json format
# @note is called on api/units/_jstree_unit.json.jbuilder
json.id bubble.id
json.text bubble.comment
json.type bubble.bubble_type_i18n
json.type_integer bubble[:bubble_type]
json.unit_id bubble.unit_id
# Renders a unit in json format
# @note is called on api/units/index.json.jbuilder
json.id unit.id
json.text unit.label
json.children unit.has_children > 0
if unit.bubbles.present?
  json.bubble do
    json.text unit.bubbles.first.comment
    json.type unit.bubbles.first.bubble_type
  end
else
  json.tree_has_bubbles unit.tree_has_bubbles?
end
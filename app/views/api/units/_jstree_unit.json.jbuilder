# Renders a unit in json format
# @note is called on api/units/index.json.jbuilder
json.id unit.id
json.text unit.label
json.children unit.has_children > 0
json.bubbles(unit.bubbles) do |bubble|
  json.partial! 'api/units/bubble', bubble: bubble
end
json.tree_has_bubbles unit.tree_children_have_bubbles?
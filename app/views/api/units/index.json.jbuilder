# Renders units in json format for jstree view
# Renders certain unit children or just roots
json.array!(@collection) do |unit|
  json.partial! 'jstree_unit', unit: unit
end
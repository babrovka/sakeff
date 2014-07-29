# Renders units in json format for jstree
# Renders certain unit children or just roots
collection = params[:id].present? && params[:id] != "#" ? Unit.children_of(params[:id]) : Unit.roots
json.array!(collection) do |unit|
  json.partial! 'units/json/jstree_unit', unit: unit
end
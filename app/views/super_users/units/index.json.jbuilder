# Child
if params[:id].present? && params[:id] != "#"
  json.array!(Unit.find(params[:id]).children) do |unit|
    json.id unit.id
    json.text unit.label
    json.children unit.has_children > 0
  end
# Root
else
  json.array!(Unit.roots) do |unit|
    json.id unit.id
    json.text unit.label
    json.children unit.has_children > 0
  end
end

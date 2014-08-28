# Renders units in json format for units view
json.array!(@collection) do |unit|
  json.partial! 'unit', unit: unit
end
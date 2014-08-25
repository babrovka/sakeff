json.array!(@collection) do |bubble|
  json.id bubble.id
  json.unit_id bubble.unit_id
  json.comment bubble.comment
end

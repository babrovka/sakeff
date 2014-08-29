json.array!(@collection) do |bubble|
  json.partial! 'bubble', bubble: bubble
end

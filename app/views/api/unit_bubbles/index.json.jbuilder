@collection.each do |key, bubbles|
  json.set! key do 
    json.partial! 'bubbles_by_type', bubbles: bubbles
  end
end
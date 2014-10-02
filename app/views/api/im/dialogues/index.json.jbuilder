json.array!(@d_dialogues) do |dialogue|
  json.partial! 'dialogue', dialogue: dialogue
end

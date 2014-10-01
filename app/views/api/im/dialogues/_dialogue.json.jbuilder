# Renders a dialogue in json format
json.sender_name dialogue.sender_name
json.receiver_id dialogue.receiver_id
json.organization_path dialogue.organization_path
json.messages_count dialogue.messages.count
json.unread "Неизвестно"

json.last_message_time dialogue.messages.any? ? messages_title_grouped_by(dialogue.date).mb_chars.capitalize : 'Никогда'
json.last_message_message dialogue.messages.created_last.text if dialogue.messages.any?

json.time dialogue.time

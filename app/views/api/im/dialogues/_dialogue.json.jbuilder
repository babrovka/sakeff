# Renders a dialogue in json format
json.sender_name dialogue.sender_name
json.receiver_id dialogue.receiver_id
json.organization_path dialogue.organization_path
json.messages_count dialogue.messages.count
json.unread "Неизвестно"
json.last_message dialogue.messages.any? ? messages_title_grouped_by(dialogue.date) : 'никогда'
json.time dialogue.time
# Renders a dialogue in json format
json.icon_html dialogue.icon_html
json.link_html dialogue.link_html
json.messages_count dialogue.messages.count
json.unread "Неизвестно"
json.last_message dialogue.messages.any? ? messages_title_grouped_by(dialogue.date) : 'никогда'
json.time dialogue.time_html
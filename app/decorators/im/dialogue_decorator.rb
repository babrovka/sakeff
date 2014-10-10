class Im::DialogueDecorator < Draper::Decorator
  decorates 'im/dialogue'
  delegate_all

  def sender
    Organization.find(object.receiver_id)
  end

  def sender_name
    sender.short_title
  end

  def receiver_id
    object.receiver_id
  end

  def organization_path
    h.messages_organization_path(receiver_id)
  end

  def link_html
    h.link_to(sender_name, organization_path)
  end

  def icon_html
    h.content_tag(:div, sender_name.first, class: "m-#{receiver_id.to_i.to_s.first} _organization-logo")
  end

  def date
    DateFormatter.new(object.messages.created_last.created_at,  :only_date).to_s if object.messages.any?
  end

  def time
    if object.messages.any?
      {first_part: ("#{DateFormatter.new object.messages.created_last.created_at, :hours_minutes}"),
      second_part: (":#{DateFormatter.new(object.messages.created_last.created_at, :seconds) }")}
    end
  end

  def time_html
    if object.messages.any?
      html = []
      html << h.content_tag(:span, time[:first_part])
      html << h.content_tag(:span, time[:second_part], class: 'text-gray')
      html.join.html_safe
    end
  end

  # Returns string amount of last received dialogue message
  # @note is used in dialogue api
  def last_message_time
    object.messages.any? ? h.messages_title_grouped_by(date) : 'Никогда'
  end


  # Returns last message text
  # @note is used in dialogue api
  def last_message_message
    object.messages.created_last.text if object.messages.any?
  end


  # Returns amount of unread messages in dialogue
  # @note is used in dialogue api
  def unread_amount
    object.unread_messages.count
  end
end

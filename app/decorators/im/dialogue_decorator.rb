class Im::DialogueDecorator < Draper::Decorator
  decorates 'im/dialogue'
  delegate_all

  def sender
    Organization.find(object.receiver_id)
  end

  def sender_name
    sender.short_title
  end

  def link_html
    h.link_to(sender_name, h.messages_organization_path(object.receiver_id))
  end

  def icon_html
    h.content_tag(:div, sender_name.first, class: "m-#{object.receiver_id.to_i.to_s.first} _organization-logo")
  end

  def date
    DateFormatter.new(object.messages.created_last.created_at,  :only_date).to_s if object.messages.any?
  end

  def time_html
    if object.messages.any?
      first_part = DateFormatter.new object.messages.created_last.created_at, :hours_minutes
      second_part = ":#{DateFormatter.new(object.messages.created_last.created_at, :seconds) }"
      html = []
      html << h.content_tag(:span, first_part)
      html << h.content_tag(:span, second_part, class: 'text-gray')
      html.join.html_safe
    end
  end

end

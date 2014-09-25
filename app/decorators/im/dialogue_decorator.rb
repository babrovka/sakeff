class Im::DialogueDecorator < Draper::Decorator
  decorates 'im/dialogue'
  delegate_all

  def sender
    Organization.find(object.first.receiver_id)
  end

  def sender_name
    sender.short_title
  end

  def icon
    h.content_tag(:div, sender_name.first, class: "m-#{object.first.receiver_id.to_i} _organization-logo")
  end

  def date
    #span.text-gray-d  #{message.created_at}
    a = DateFormatter.new object.first.messages.created_last.created_at,  :only_date
    a.to_s
  end

  def time
    first_part = DateFormatter.new object.first.messages.created_last.created_at, :hours_minutes
    second_part = ":#{DateFormatter.new(object.first.messages.created_last.created_at, :seconds) }"
    html = []
    html << h.content_tag(:span, first_part)
    html << h.content_tag(:span, second_part, class: 'text-gray')

    html.join.html_safe
  end

end

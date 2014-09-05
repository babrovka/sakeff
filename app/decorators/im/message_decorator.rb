class Im::MessageDecorator < Draper::Decorator
  decorates 'im/message'
  delegate_all

  def date
    DateFormatter.new object.created_at, :only_time
  end

  def date_html
    first_part = DateFormatter.new object.created_at, :hours_minutes
    second_part = ":#{DateFormatter.new(object.created_at, :seconds) }"
    html = []
    html << h.content_tag(:span, first_part)
    html << h.content_tag(:span, second_part, class: 'text-gray')

    html.join.html_safe
  end

end

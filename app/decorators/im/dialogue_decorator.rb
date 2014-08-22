class Im::DialogueDecorator < Draper::Decorator
  decorates 'im/dialogue'
  delegate_all

  def users_list_html
    object.users.map do |user|
      user = UserDecorator.decorate(user)
      # h.content_tag(:span, user.full_name_fl)
      user.full_name_fl
    end.compact.join(', ').html_safe
  end

  def last_message
    @last_message ||= Im::MessageDecorator.decorate object.messages.order('created_at DESC').limit(1).first
  end

end

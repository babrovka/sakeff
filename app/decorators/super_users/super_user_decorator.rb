class SuperUsers::SuperUserDecorator < Draper::Decorator
  decorates :super_user
  delegate_all

  def name
    object.label || "Супер пользователь"
  end

  def html_name
    name.split(' ').map do |str|
      h.content_tag(:span, str)
    end.join().html_safe
  end

end

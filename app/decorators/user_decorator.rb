class UserDecorator < Draper::Decorator
  decorates :user
  delegate_all


  # Returns nick if name is blank
  def any_name
    self.name.present? ? self.name : self.object.username
  end

  # Returns name and surname if it's present
  def name
    object.last_name.present? ? "#{object.first_name} #{object.last_name}" : object.first_name
  end

  def html_name
    name.split(' ').map do |str|
      h.content_tag(:span, str)
    end.join().html_safe
  end

  def image_path type = :page
    _type = "#{type.to_s.gsub('_image', '')}_image".to_sym
    h.user_image_path(user: object.id, image_type: _type)
  end

end

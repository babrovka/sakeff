class UserDecorator < Draper::Decorator
  decorates :user
  delegate_all


  # Returns nick if name is blank
  def any_name
    self.full_name_fl.present? ? self.full_name_fl : self.object.username
  end

  # return full name in direction Name MiddleName Surname
  def full_name_fml
    name = []
    name << object.try(:first_name)
    name << object.try(:last_name)
    name << object.try(:middle_name)
    name.compact.join(' ')
  end

  # return full name in direction Surname Name MiddleName
  def full_name_lfm
    name = []
    name << object.try(:last_name)
    name << object.try(:first_name)
    name << object.try(:middle_name)
    name.compact.join(' ')
  end

  # return full name in direction Name Surname
  def full_name_fl
    name = []
    name << object.try(:first_name)
    name << object.try(:last_name)
    name.compact.join(' ')
  end

  def html_name
    any_name.split(' ').map do |name_part|
      h.content_tag(:span, name_part)
    end.join().html_safe
  end

  def image_path type = :page
    _type = "#{type.to_s.gsub('_image', '')}_image".to_sym
    h.user_image_path(user: object.id, image_type: _type)
  end

end

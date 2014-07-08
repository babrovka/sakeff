class SuperUsers::UserDecorator < Draper::Decorator
  decorates :user
  delegate_all

  def name
    str = "#{object.first_name} #{object.last_name}"
    'Без Имени и Фамилии' if str.blank?
  end

end

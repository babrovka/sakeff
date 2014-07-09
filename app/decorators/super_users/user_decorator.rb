class SuperUsers::UserDecorator < Draper::Decorator
  decorates :user
  delegate_all

  def name
    str = "#{object.first_name} #{object.last_name}"
    str = 'Без Имени и Фамилии' if str.blank?
    str
  end
  #
  #def organization
  #  org = Organization.find(object.organization_id).short_title
  #
  #end
end

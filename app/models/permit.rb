# == Schema Information
#
# Table name: permits
#
#  id           :integer          not null, primary key
#  first_name   :string(255)
#  last_name    :string(255)
#  middle_name  :string(255)
#  doc_type     :integer
#  doc_number   :string(255)
#  vehicle_type :integer
#  car_brand    :string(255)
#  car_number   :string(255)
#  region       :string(255)
#  drive_list   :boolean          default(FALSE)
#  person       :string(255)
#  location     :string(255)
#  starts_at    :datetime
#  expires_at   :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class Permit < ActiveRecord::Base
  
  enum doc_type: [ :passport, :driver_licence ]
  enum vehicle_type: [ :passenger, :truck ]
  
  validates_datetime :expires_at, :on_or_after => :starts_at, allow_blank: true
  validates_datetime :starts_at, :on_or_after => Time.now, allow_blank: true
  
  validate :check_empty_fields
  
  def check_empty_fields
    unless self.once? || self.car? || self.human?
      errors.add(:base, "Пожалуйста заполните поля, хотя бы для одного из типов пропуска")
    end
  end
  
  def once?
    if person && location && starts_at && expires_at && starts_at == expires_at && (first_name && last_name && middle_name && doc_type && doc_number || drive_list)
      true
    else
      false
    end
  end
  
  def car?
    if vehicle_type && car_brand && car_number && region
      true
    else
      false
    end
  end
  
  def human?
    if first_name && last_name && middle_name && doc_type && doc_number && drive_list == false
      true
    else
      false
    end
  end
  
  def drive_list?
    if vehicle_type && car_brand && car_number && region && (first_name.blank? || last_name.blank? || middle_name.blank?)
      true
    else
      false
    end
  end
  
  def expired?
    if expires_at && expires_at >= Time.now 
      false
    else
      true
    end
  end
  
end

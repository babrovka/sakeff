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
#  once         :boolean          default(FALSE)
#  car          :boolean          default(FALSE)
#  human        :boolean          default(FALSE)
#

class Permit < ActiveRecord::Base
  
  enum doc_type: [ :passport, :driver_licence ]
  enum vehicle_type: [ :passenger, :truck ]
  
  validates_datetime :expires_at, :on_or_after => :starts_at, allow_blank: true
  validates_datetime :starts_at, :on_or_after => Time.now, allow_blank: true

  default_scope { order('created_at DESC') }
  
  before_save :assign_types
  
  scope :once, -> {where(once: true)}
  scope :car, -> {where(car: true)}
  scope :human, -> {where(human: true)}
  
  validate :check_empty_fields
  
  def check_empty_fields
    unless self.once? || self.car? || self.human?
      errors.add(:base, "Пожалуйста заполните поля, хотя бы для одного из типов пропуска")
    end
  end
  
  # checks if we can print once-only permit template
  def once?
    person && location && starts_at && expires_at && starts_at == expires_at && (human?  || drive_list)
  end
  
  # checks if we can print car permit template
  def car?
    vehicle_type && car_brand && car_number && region
  end
  
  # checks if we can print human permit template
  def human?
    first_name && last_name && middle_name && doc_type && doc_number && drive_list == false
  end
  
  # check if permit contains info about vehicle but person
  def drive_list?
   vehicle_type && car_brand && car_number && region && (first_name.blank? || last_name.blank? || middle_name.blank?)
  end
  
  # check if permit expired
  def expired?
    expires_at && expires_at < Time.now
  end
  
  def assign_types
    self.once = true if self.once?
    self.car = true if self.car?
    self.human = true if self.human?
  end
  
end

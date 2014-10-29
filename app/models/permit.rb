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
  
  validates_datetime :expires_at, on_or_after: :starts_at, allow_blank: true, on: :create
  validates_datetime :starts_at, on_or_after: Time.now, allow_blank: true

  default_scope { order('created_at DESC') }

  scope :once, -> {where(once: true)}
  scope :car, -> {where(car: true)}
  scope :human, -> {where(human: true)}


  # Returns permit type
  # @note is used on update callbacks to define an index type
  def type
    return "once" if once?
    return "car" if car?
    return "human" if human?
  end

  
  # checks if we can print once-only permit template
  def once?
    person.present? && location.present? && starts_at.present? && expires_at.present? && starts_at == expires_at && human?
  end
  
  # checks if we can print car permit template
  def car?
    car_brand.present? && car_number.present? && region.present?
  end
  
  # checks if we can print human permit template
  def human?
    first_name.present? && last_name.present? && middle_name.present? && doc_type.present? && doc_number.present? # && drive_list == false
  end

  # temp commented because drive list is not used
  # check if permit contains info about vehicle but person
  # def drive_list?
  #  car_brand && car_number && region && (first_name.blank? || last_name.blank? || middle_name.blank?)
  # end
  
  # check if permit expired
  def expired?
    expires_at && expires_at < Time.now
  end
  
  def assign_types
    self.once = self.once?
    self.car = self.car?
    self.human = self.human?
    # self.drive_list = self.drive_list?
    self.save
  end
  
end

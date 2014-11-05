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
#  organization :string(255)
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

  validate :check_empty_fields



  before_save :update_type_fields
  before_save :assign_types

  # Returns permit type
  # @note is used on update callbacks to define an index type
  def type
    return "once" if once?
    return "car" if car?
    "human"
  end

  
  # checks if we can print once-only permit template
  def once?
    person.present? && location.present? && starts_at.present? && expires_at.present? && starts_at == expires_at
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
    expires_at.present? && expires_at < Time.now
  end


  # Assigns types depending on different checks
  # @note is called before save
  def assign_types
    self.once = once?
    self.car = car?
    self.human = human?
    # self.drive_list = self.drive_list?
    true
  end


  # Updates type fields according to checked types
  # @note is called before save
  def update_type_fields
    resolve_once_fields
    resolve_car_fields
  end


  # Updates fields related to once permit according to once checkbox
  def resolve_once_fields
    # If it's a once permit set starts at for expires at
    if once
      self.starts_at = expires_at
      # Else remove once fields
    else
      self.location = ""
      self.person = ""
    end
  end

  def resolve_car_fields
    # If it's not a car type remove car fields
    unless car
      self.car_brand = ""
      self.car_number = ""
      self.region = ""
    end
  end

  def check_empty_fields
    unless once? || car? || human?
      errors.add(:base, "Пожалуйста заполните поля, хотя бы для одного из типов пропуска")
    end
  end
end

# == Schema Information
#
# Table name: units
#
#  id           :uuid             not null, primary key
#  label        :string(255)      not null
#  parent_id    :uuid
#  has_children :integer          default(0)
#  created_at   :datetime
#  updated_at   :datetime
#  filename     :string(255)
#  lft          :integer
#  rgt          :integer
#

class Unit < ActiveRecord::Base
  include Uuidable

  attr_reader :file_type

  has_many :bubbles, class_name: :UnitBubble
  acts_as_nested_set

  # @todo babrovka it doesn't seem to work properly, it just returns all Units
  scope :with_children, -> {where.not(rgt: nil)}

  # типы файлов, которые могут быть прикреплены к объекту
  def file_type
    if filename.present?
      if filename.include?('.dae')
        :volume
      elsif filename.match(/jpg|png|jpeg|bmp|gif/).present?
        :plain
      end
    end
  end



  # Favs this unit by a certain user
  # @param user [User]
  # @note is used in UnitsController on fav action
  def favourite_for_user(user)
    user.favourite_units.create(unit: self)
  end


  # Favs this unit by a certain user
  # @param user [User]
  # @return [Boolean]
  # @note is used in UnitsController on fav action
  def is_favourite_of_user?(user)
    user.favourite_units.where(unit: self).exists?
  end

end

# == Schema Information
#
# Table name: units
#
#  id             :uuid             not null, primary key
#  label          :string(255)      not null
#  parent_id      :uuid
#  has_children   :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#  model_filename :string(255)
#  lft            :integer
#  rgt            :integer
#

class Unit < ActiveRecord::Base
  include Uuidable
  has_many :bubbles, class_name: :UnitBubble, dependent: :destroy
  acts_as_nested_set

  scope :with_children, -> {where.not(rgt: nil)}

end

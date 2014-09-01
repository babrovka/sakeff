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
  has_many :bubbles, class_name: :UnitBubble
  acts_as_nested_set
  # Returns root or children units
  # @param parent_id [Integer] id or unit parent record
  # @return [Active Record Array]
  scope :tree_units, -> (parent_id) do
    parent_id.present? && parent_id != "#" ? Unit.find(parent_id).children : Unit.roots
  end

  scope :with_children, -> {where.not(rgt: nil)}

  # Shows whether does a units descendants have any bubbles
  # @note is called in tree rendering
  # @return [Boolean]
  def tree_children_have_bubbles?
    children_have_bubbles = -> (unit) do
      if unit.bubbles.size > 0
        return true
      else
        unit.children.map {|child| return children_have_bubbles.call(child) }
      end
      false
    end

    self.children.map(&children_have_bubbles).any?
  end

end

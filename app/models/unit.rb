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
#

class Unit < ActiveRecord::Base
  include Uuidable
  extend ActsAsTree::TreeView
  acts_as_tree order: "label"
  has_many :bubbles, class_name: :UnitBubble

  # Returns root or children units
  # @param parent_id [Integer] id or unit parent record
  # @return [Active Record Array]
  scope :tree_units, -> (parent_id) do
    parent_id.present? && parent_id != "#" ? Unit.find(parent_id).children : Unit.roots
  end

  # Shows whether does a unit and all its descendants have any bubbles
  # @note is called in tree rendering
  # @return [Boolean]
  def tree_has_bubbles?
    if self.bubbles.size > 0
      return true
    else
      self.children.each {|child| return true if child.tree_has_bubbles? }
    end
    false
  end
end
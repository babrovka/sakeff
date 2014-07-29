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
  extend ActsAsTree::TreeView
  acts_as_tree order: "label"

  # Returns children of a unit
  # @param parent_id [Integer] id or unit parent record
  # @return [Active Record Array]
  scope :children_of, -> (parent_id) { Unit.find(parent_id).children }

  # Returns root or children units
  # @param parent_id [Integer] id or unit parent record
  # @return [Active Record Array]
  scope :tree_units, -> (parent_id) { parent_id != "#" ? Unit.children_of(parent_id) : Unit.roots }
end
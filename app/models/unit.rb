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
  has_many :unit_bubbles

  # Returns root or children units
  # @param parent_id [Integer] id or unit parent record
  # @return [Active Record Array]
  scope :tree_units, -> (parent_id) do
    parent_id.present? && parent_id != "#" ? Unit.find(parent_id).children : Unit.roots
  end
end
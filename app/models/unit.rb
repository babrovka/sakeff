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
end

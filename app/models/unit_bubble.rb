# == Schema Information
#
# Table name: unit_bubbles
#
#  id          :uuid             not null, primary key
#  bubble_type :integer          not null
#  comment     :text
#  created_at  :datetime
#  updated_at  :datetime
#  unit_id     :uuid
#

class UnitBubble < ActiveRecord::Base
  include Uuidable
  enum bubble_type: [ :facilities_accident, :work, :information, :emergency ]
  belongs_to :unit
  
  def self.children_bubble_by_type(unit)
    UnitBubble.joins(:unit).where("units.lft >= ? AND units.rgt < ?", unit.left, unit.right).group_by(&:bubble_type)
  end
  
  def self.grouped_bubbles_for_all_units
    Unit.with_children.map do |unit|
      self.count_bubbles_by_type(unit)
    end.compact.select { |h| h.present? }
  end
  
  def self.count_bubbles_by_type(unit)
    h = {}
    self.children_bubble_by_type(unit).each do |bubble_type, bubbles|  
        h[bubble_type] = bubbles.count unless bubbles.empty?
    end
    p = {}
    p[unit.id] = h
    p.delete_if { |key, value| value.blank? }
  end
end

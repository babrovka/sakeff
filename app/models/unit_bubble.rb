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
  
  def self.grouped_bubbles
    sql_query = (<<-SQL)
    select units.id, bubbles.bubble_type, count(bubbles) from units 
    join unit_bubbles bubbles on bubbles.unit_id = units.id 
    group by units.id, bubbles.bubble_type
      SQL
      
    ActiveRecord::Base.connection.execute(sql_query).to_a
    
    
  end

  # @todo babrovka write comments
  def self.bubbles_by_type_of_unit(unit)
    UnitBubble.joins(:unit).where("units.lft >= ? AND units.rgt < ? OR units.id = ?", unit.left, unit.right, unit.id).group_by(&:bubble_type)
  end

  def self.grouped_bubbles_for_all_units
    Unit.all.map do |unit|
      self.count_bubbles_by_type(unit)
    end.compact.select { |h| h.present? }
  end

  def self.count_bubbles_by_type(unit)
    h = {}
    self.bubbles_by_type_of_unit(unit).each do |bubble_type, bubbles|
      h[UnitBubble.bubble_types[bubble_type]] = {name: bubble_type, russian_name: I18n.t("enums.unit_bubble.bubble_type.#{bubble_type}"), count: bubbles.count} unless bubbles.empty?
    end
    unless h.blank?
      p = {}
      p[:unit_id] = unit.id.upcase
      p[:bubbles] = h

      p.delete_if { |key, value| value.blank? }
    end
  end
end

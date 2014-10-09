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
  enum bubble_type: [ :emergency, :work, :information ]
  belongs_to :unit

  # returns array e.g.
  # [{:unit_id=>"0d71d40e-f729-493e-a6c6-567c10086a96", :bubbles=>{
  #   "0"=>{:name=>"facilities_accident", :russian_name=>"Аварии оборудования", :count=>"1"},
  #   "3"=>{:name=>"emergency", :russian_name=>"ЧП", :count=>"1"},
  #  "2"=>{:name=>"information", :russian_name=>"Информация", :count=>"1"},
  #  "1"=>{:name=>"work", :russian_name=>"Работы", :count=>"1"}}}]

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
      h[UnitBubble.bubble_types[bubble_type]] = {name: bubble_type, russian_name: bubble_type_russian_name(bubble_type), count: bubbles.count} unless bubbles.empty?
    end
    unless h.blank?
      p = {}
      p[:unit_id] = unit.id.upcase
      p[:bubbles] = h

      p.delete_if { |key, value| value.blank? }
    end
  end


  # Gets russian name for a bubble type
  # @note is called in api methods
  def self.bubble_type_russian_name(bubble_type)
    I18n.t("enums.unit_bubble.bubble_type.#{bubble_type}")
  end

end
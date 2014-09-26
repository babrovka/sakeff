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
  
  def self.grouped_bubbles_for_all_units
    self.sql.group_by do |x|
      x['id']
    end.map do |k, v|
      b = {}
      v.each do |t|
        type_name = UnitBubble.bubble_types.key(t['bubble_type'].to_i)
        b[t['bubble_type']] = {
          name: type_name,
          russian_name: I18n.t(type_name, scope: "enums.unit_bubble.bubble_type."),
          count: t['count']
        }
      end
      {unit_id: k, bubbles: b}
    end
  end
  
  def self.sql
    sql_query = (<<-SQL)
    select units.id, bubbles.bubble_type, count(bubbles) from units 
    join unit_bubbles bubbles on bubbles.unit_id = units.id 
    group by units.id, bubbles.bubble_type
      SQL
    ActiveRecord::Base.connection.execute(sql_query).to_a
  end

end

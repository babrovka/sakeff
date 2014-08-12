# == Schema Information
#
# Table name: unit_bubbles
#
#  id          :uuid             not null, primary key
#  bubble_type :integer          not null
#  comment     :text
#  unit_id     :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class UnitBubble < ActiveRecord::Base
  enum bubble_type: [ :type1, :type2, :type3 ]
  belongs_to :unit
end

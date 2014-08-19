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
end

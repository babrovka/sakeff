# == Schema Information
#
# Table name: control_regulation_state_events
#
#  id                       :integer          not null, primary key
#  name                     :string(255)
#  system_name              :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  from_regulation_state_id :uuid
#  to_regulation_state_id   :uuid
#

class Control::RegulationStateEvent < ActiveRecord::Base
  belongs_to :regulation_state
  belongs_to :target_state, foreign_key: 'to_regulation_state_id', class_name: 'Control::RegulationState'
end

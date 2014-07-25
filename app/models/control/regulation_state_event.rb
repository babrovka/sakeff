# == Schema Information
#
# Table name: control_events
#
#  id            :integer          not null, primary key
#  from_state_id :integer
#  to_state_id   :integer
#  name          :string(255)
#  system_name   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Control::RegulationStateEvent < ActiveRecord::Base
  belongs_to :regulation_state
  belongs_to :target_state, foreign_key: 'to_regulation_state_id', class_name: 'Control::RegulationState'
end

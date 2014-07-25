# == Schema Information
#
# Table name: control_states
#
#  id          :uuid             not null, primary key
#  name        :string(255)
#  system_name :string(255)
#

class Control::RegulationState < ActiveRecord::Base
  belongs_to :regulation
  has_many :events, foreign_key: 'from_regulation_state_id'

  has_one :targetted_event, class_name: 'Control::RegulationStateEvent'

end

# == Schema Information
#
# Table name: control_regulation_states
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  system_name   :string(255)
#  regulation_id :uuid
#  created_at    :datetime
#  updated_at    :datetime
#

class Control::RegulationState < ActiveRecord::Base
  belongs_to :regulation
  has_many :events, foreign_key: 'from_regulation_state_id'

  has_one :targetted_event, class_name: 'Control::RegulationStateEvent'

end

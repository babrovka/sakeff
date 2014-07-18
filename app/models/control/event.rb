class Control::Event < ActiveRecord::Base
  belongs_to :state
  belongs_to :target_state, foreign_key: 'to_state_id', class_name: 'Control::State'
end

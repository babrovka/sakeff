class Control::State < ActiveRecord::Base
  belongs_to :regulation
  has_many :events, foreign_key: 'from_state_id'

  has_one :targetted_event, class_name: 'Control::Event'

end

# == Schema Information
#
# Table name: control_regulations
#
#  id         :uuid             not null, primary key
#  name       :string(255)
#  state_id   :uuid
#  role_id    :uuid
#  created_at :datetime
#  updated_at :datetime
#

class Control::Regulation < ActiveRecord::Base
  has_many :regulation_states

  # default_scope { order('id') }

end

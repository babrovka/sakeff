# == Schema Information
#
# Table name: control_regulations
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  activated_at :datetime
#

class Control::Regulation < ActiveRecord::Base
  has_many :states

  # default_scope { order('id') }

end

# == Schema Information
#
# Table name: control_states
#
#  id          :uuid             not null, primary key
#  name        :string(255)
#  system_name :string(255)
#  is_normal   :boolean
#

class Control::State < ActiveRecord::Base
  
end

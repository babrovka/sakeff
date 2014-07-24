# == Schema Information
#
# Table name: user_roles
#
#  id         :integer          not null, primary key
#  user_id    :uuid
#  role_id    :uuid
#  created_at :datetime
#  updated_at :datetime
#

class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end

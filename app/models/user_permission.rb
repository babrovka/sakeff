# == Schema Information
#
# Table name: user_permissions
#
#  id            :integer          not null, primary key
#  user_id       :uuid
#  permission_id :uuid
#  result        :integer          default(0), not null
#  created_at    :datetime
#  updated_at    :datetime
#

class UserPermission < ActiveRecord::Base

  validates :result, presence: true
  validates :permission, presence: true

  belongs_to :user
  belongs_to :permission
  enum result: [ :default, :granted, :forbidden ]
end

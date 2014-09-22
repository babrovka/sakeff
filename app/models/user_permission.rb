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
# Indexes
#
#  by_user_and_permission  (user_id,permission_id) UNIQUE
#

class UserPermission < ActiveRecord::Base

  validates :result, presence: true
  validates :permission, presence: true
  
  validates :permission_id, uniqueness: { scope: :user_id }

  belongs_to :user
  belongs_to :permission
  enum result: [ :default, :granted, :forbidden ]
end

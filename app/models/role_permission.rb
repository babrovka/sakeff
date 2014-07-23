# == Schema Information
#
# Table name: role_permissions
#
#  id            :integer          not null, primary key
#  role_id       :uuid
#  permission_id :uuid
#  result        :integer          default(0), not null
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_role_permissions_on_role_id_and_permission_id  (role_id,permission_id) UNIQUE
#

class RolePermission < ActiveRecord::Base
  belongs_to :role
  belongs_to :permission
  enum result: [ :default, :granted, :forbidden ]
end

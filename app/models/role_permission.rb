class RolePermission < ActiveRecord::Base
  belongs_to :role
  belongs_to :permission
  enum result: [ :default, :granted, :forbidden ]

  validates :result, :presence => true
  validates :permission_id, :presence => true
end

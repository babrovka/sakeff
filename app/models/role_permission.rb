class RolePermission < ActiveRecord::Base
  belongs_to :role
  belongs_to :permission
  enum result: [ :default, :granted, :forbidden ]

  # validates :role_id, :uniqueness => {:scope => :permission_id, :message => "Нельзя дублировать право у роли"}

end

class Role < ActiveRecord::Base
  validates :title, :description, presence: true
  has_many :role_permissions
  has_many :permissions, through: :role_permissions
  has_many :user_roles
  has_many :users, through: :user_roles



  def permission_result(permission)
    if permission && permission.is_a?(Permission)
      RolePermission.where(role_id: self.id, permission_id: permission.id).first.try(:result)
    end
  end
end

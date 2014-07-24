# == Schema Information
#
# Table name: roles
#
#  id          :uuid             not null, primary key
#  title       :string(32)       not null
#  description :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Role < ActiveRecord::Base
  validates :title, :description, presence: true
  validates :title, uniqueness: true
  has_many :role_permissions
  has_many :permissions, through: :role_permissions
  has_many :user_roles
  has_many :users, through: :user_roles
  accepts_nested_attributes_for :role_permissions, :allow_destroy => true

  around_save :catch_duplicates_error

  def permission_result(permission)
    if permission && permission.is_a?(Permission)
      RolePermission.where(role_id: self.id, permission_id: permission.id).first.try(:result)
    end
  end

  # Handles duplicated role permissions errors
  # @note yield = save method
  def catch_duplicates_error
    begin
      yield
    rescue Exception
      errors.add(:permission, "Нельзя дублировать право у роли")
      false
    end
  end
end

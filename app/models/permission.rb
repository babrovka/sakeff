class Permission < ActiveRecord::Base
  validates :description, presence: true
  validates :title, uniqueness: true,
                    presence: true,
                    format: { with: /\A[a-z0-9_]+\Z/ }

  has_many :user_permissions
  has_many :users, through: :user_permissions
  has_many :role_permissions
  has_many :roles, through: :role_permissions
end

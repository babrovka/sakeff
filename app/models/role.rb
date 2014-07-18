class Role < ActiveRecord::Base
  validates :title, :description, presence: true
  validates :title, uniqueness: true
  has_many :role_permissions
  has_many :permissions, through: :role_permissions
  has_many :user_roles
  has_many :users, through: :user_roles
end

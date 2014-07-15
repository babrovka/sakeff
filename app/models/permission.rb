class Permission < ActiveRecord::Base
  validates :title, :description, presence: true
  has_many :user_permissions
  has_many :users, through: :user_permissions
end

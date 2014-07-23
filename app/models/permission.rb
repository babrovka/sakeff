# == Schema Information
#
# Table name: permissions
#
#  id          :uuid             not null, primary key
#  title       :string(32)       not null
#  description :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Permission < ActiveRecord::Base
  validates :title, :description, presence: true
  has_many :user_permissions
  has_many :users, through: :user_permissions
  has_many :role_permissions
  has_many :roles, through: :role_permissions
end

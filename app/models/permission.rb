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
  include Uuidable
  validates :description, format: { with: /\A[А-яЁё\w\s]+\Z/u }
  validates :title, uniqueness: true,
                    presence: true,
                    format: { with: /\A[a-z0-9_]+\Z/ }

  has_many :user_permissions
  has_many :users,  -> { uniq }, through: :user_permissions
  has_many :role_permissions
  has_many :roles,  -> { uniq }, through: :role_permissions
end

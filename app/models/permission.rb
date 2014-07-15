class Permission < ActiveRecord::Base
  validates :title, :description, presence: true
end

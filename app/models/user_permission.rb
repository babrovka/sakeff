class UserPermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :permission
  enum result: [ :default, :granted, :forbidden ]
end

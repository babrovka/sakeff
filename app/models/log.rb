# == Schema Information
#
# Table name: logs
#
#  id         :integer          not null, primary key
#  scope      :string(32)       not null
#  user_id    :uuid             not null
#  obj_id     :uuid
#  event_type :string(64)       not null
#  result     :string(32)       not null
#  comment    :string(1024)
#  created_at :datetime
#  updated_at :datetime
#

class Log < ActiveRecord::Base
  validates :scope, :user_id, :event_type, :result, presence: true
  validates :result, inclusion: {in: %w(Success Error)}
  
  scope :auth_logs, -> { where(scope: 'auth_logs') }
  scope :user_logs, -> { where(scope: 'user_logs') }
  
end

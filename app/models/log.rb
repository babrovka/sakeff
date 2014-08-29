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
  validates :result, inclusion: {in: %w(Success Error)}
  validates :scope, format: { with: /\A[a-z0-9_]+\Z/ }
  validates :event_type, format: { with: /\A[a-zA-Z0-9_]+\Z/ }
  # validates :comment, format: { with: /\A[\w\s]+\Z/ }
  
  scope :auth_logs, -> { where(scope: 'auth_logs') }
  scope :action_logs, -> { where(scope: 'action_logs') }

  default_scope -> { order('created_at DESC') }


  before_validation :empty_uuid


  private

  def empty_uuid
    self.user_id ||= '00000000-0000-0000-0000-000000000000'
  end
  
end

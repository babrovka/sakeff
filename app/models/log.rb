class Log < ActiveRecord::Base
  validates :scope, :user_id, :event_type, :result, presence: true
  validates :result, :inclusion => { :in => %w(Success Error)}
  
  scope :auth_logs, -> { where(scope: 'auth_logs') }
  scope :user_logs, -> { where(scope: 'user_logs') }
  
end

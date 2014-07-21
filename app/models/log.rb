class Log < ActiveRecord::Base
  validates :scope, :user_id, :event_type, :result, presence: true
  validates :result, :inclusion => { :in => %w(Success Error)}
end

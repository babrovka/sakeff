module Ringbell
  class Notification < ActiveRecord::Base
    self.table_name = 'ringbell_notifications'

    belongs_to :notifiable, polymorphic: true
    belongs_to :user
    belongs_to :changer, class_name: 'User', foreign_key: 'changer_id'
  end
end
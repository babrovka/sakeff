# == Schema Information
#
# Table name: ringbell_notifications
#
#  id              :integer          not null, primary key
#  notifiable_type :string(255)
#  user_id         :uuid             not null
#  message         :string(255)
#  notifiable_id   :integer
#

module Ringbell
  class Notification < ActiveRecord::Base
    self.table_name = 'ringbell_notifications'

    belongs_to :notifiable, polymorphic: true
    belongs_to :user
    belongs_to :changer, class_name: 'User', foreign_key: 'changer_id'
  end
end

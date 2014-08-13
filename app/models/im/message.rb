# == Schema Information
#
# Table name: im_messages
#
#  id           :integer          not null, primary key
#  text         :text
#  sender_id    :integer
#  recipient_id :integer
#  opened       :boolean
#  private      :boolean
#  sent_at      :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class Im::Message < ActiveRecord::Base
end

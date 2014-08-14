# == Schema Information
#
# Table name: im_messages
#
#  id         :uuid             not null, primary key
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#  sender_id  :uuid
#

class Im::Message < ActiveRecord::Base

  attr_reader :send_to_all

  has_and_belongs_to_many :recipients,
                          class_name: "User",
                          join_table: "message_recipients",
                          foreign_key: "message_id",
                          association_foreign_key: "user_id"

end

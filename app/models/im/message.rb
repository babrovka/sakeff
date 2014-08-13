# == Schema Information
#
# Table name: im_messages
#
#  id         :uuid             not null, primary key
#  text       :text
#  sender_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Im::Message < ActiveRecord::Base

  has_and_belongs_to_many :recipients,
                          class_name: "User",
                          uniq: true,
                          join_table: "message_recipients",
                          foreign_key: "message_id",
                          association_foreign_key: "user_id"

end

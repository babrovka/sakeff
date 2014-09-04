# == Schema Information
#
# Table name: im_messages
#
#  id           :uuid             not null, primary key
#  text         :text
#  created_at   :datetime
#  updated_at   :datetime
#  sender_id    :uuid
#  dialogue_id  :uuid
#  message_type :integer          default(0)
#

class Im::Message < ActiveRecord::Base
  include Uuidable

  enum message_type: [:broadcast]

  has_and_belongs_to_many :recipients,
                          class_name: "User",
                          join_table: "message_recipients",
                          foreign_key: "message_id",
                          association_foreign_key: "user_id"

  belongs_to :sender, class_name: "User",
             foreign_key: "sender_id"


  validates :text, presence: true

  def type
    message_type
  end

end

# == Schema Information
#
# Table name: im_messages
#
#  id             :uuid             not null, primary key
#  text           :text
#  created_at     :datetime
#  updated_at     :datetime
#  sender_id      :uuid
#  reach          :integer          default(0)
#  receiver_id    :uuid
#  sender_user_id :uuid
#

class Im::Message < ActiveRecord::Base
  include Uuidable
  include RingBell

  default_interesants :receivers
  enum reach: [:broadcast]

  belongs_to :sender, class_name: "User", foreign_key: "sender_user_id"

  validates :text, presence: true

  after_create :notify_interesants

  def receivers
    User.all.to_a
  end

end

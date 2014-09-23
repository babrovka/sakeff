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
  enum reach: [:broadcast, :organization]

  belongs_to :sender, class_name: "User", foreign_key: "sender_user_id"

  validates :text, presence: true

  after_create :notify_interesants
  
  def receiver
    if receiver_type == 'broadcast'
      receivers
    elsif receiver_type == 'organization'
      Organization.where(id: receiver_id).first
    else
      nil
    end
  end
  
  def receiver_type
    ['broadcast','organization'].include?(reach.to_s) ? reach : 'undefined'
  end

  def receivers
    User.all.to_a
  end

end

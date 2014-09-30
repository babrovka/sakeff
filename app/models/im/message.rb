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
  include Notifier

  acts_as_notifier do
    interesants :receivers
    engines NotificationEngine::Mail
  end

  enum reach: [:broadcast, :organization]

  belongs_to :sender, class_name: "User", foreign_key: "sender_user_id"

  validates :text, presence: true

  after_create :notify_interesants
  
  def receivers
      case reach 
        when 'broadcast'
          User.all.reject {|u| u == sender }.to_a
        when 'organization'
          User.where(organization_id: [sender_id, receiver_id]).to_a.compact.uniq.reject {|u| u == sender}
        else
          raise RuntimeError, "Reach #{reach} is not supported"
      end
  end

  # For front-end
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
    ['broadcast','organization'].include?(reach.to_s) ? reach.to_s : 'undefined'
  end
  # / For front-end

end

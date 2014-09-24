class Im::Dialogue
  attr_accessor :sender_id,
                :receiver_id,
                :receiver

  def initialize(reach, sender_id = nil, receiver_id = nil)
    raise Exception "Reach '#{reach}' is not supported" unless [:broadcast, :organization].include?(reach)
    @reach = reach
    @sender_id = sender_id
    @reciever_id = reciever_id
  end

  def messages
    case @reach
      when :broadcast
        Im::Message.broadcast.order('created_at DESC')
      when :organization
        Im::Message.organization.where("im_messages.sender_id = ? AND im_messages.receiver_id = ? OR im_messages.sender_id = ? AND im_messages.receiver_id = ?", @sender_id, @reciever_id, @reciever_id, @sender_id)
      else 
        raise RuntimeError
    end
  end

  def send message, options = {}
    # умолчания
    options = options.reverse_merge({force: false})
    case @reach
      when :broadcast
        message.reach = :broadcast
        options[:force] ? message.save! : message.save
      when :organization
        options[:force] ? create_organizations_message(message).save! : create_organizations_message(message).save
      else
        raise RuntimeError
    end
  end
  
  def create_organizations_message(message)
    message.reach = :organization
    user = User.where(id: message.sender_user_id).first
    sender_organization = Organization.where(id: user.organization_id).first
    message.sender_id = sender_organization.id
    message
  end

  def receiver
    case @reach
      when :organization
        Organization.where(id: @receiver_id)
      else
        nil
    end
  end
end
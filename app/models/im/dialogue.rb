class Im::Dialogue

  def initialize reach
    raise Exception "Reach '#{reach}' is not supported" unless (reach != :broadcast || reach != :organization)
    @reach = reach
  end

  def messages(sender_id=nil, reciever_id=nil)
    case @reach
      when :broadcast
        Im::Message.broadcast.order('created_at DESC')
      when :organization
        Im::Message.organization.where("im_messages.sender_id = ? AND im_messages.receiver_id = ? OR im_messages.sender_id = ? AND im_messages.receiver_id = ?", sender_id, reciever_id, reciever_id, sender_id)
      else 
        raise RuntimeError
    end
  end

  def send message, options = {}
    # умолчания
    options.reverse_merge({force: false})

    case @reach
      when :broadcast
        message.reach = :broadcast
        options[:force] ? message.save! : message.save
      when :organization
        message.reach = :organization
        user = User.where(id: message.sender_user_id).first
        sender_organization = Organization.where(id: user.organization_id).first
        message.sender_id = sender_organization.id
        options[:force] ? message.save! : message.save
      else
        raise RuntimeError
    end
  end
end
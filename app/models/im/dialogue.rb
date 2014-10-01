class Im::Dialogue

  attr_reader :receiver_id

  def initialize(user, reach, receiver_id = nil)
    raise Exception "Reach '#{reach}' is not supported" unless [:broadcast, :organization].include?(reach)

    @user = user
    @reach = reach

    if reach == :organization
      @sender_id = user.organization.id
      @receiver_id = receiver_id
    end
  end

  def messages
    case @reach
      when :broadcast
        Im::Message.broadcast.order('created_at DESC')
      when :organization
        Im::Message.organization
                    .where("im_messages.sender_id = ? AND im_messages.receiver_id = ? OR im_messages.sender_id = ? AND im_messages.receiver_id = ?", @sender_id, @receiver_id, @receiver_id, @sender_id)
                    .order('created_at DESC')
      else 
        raise RuntimeError
    end
  end

  def unread_messages
    messages.with_notifications_for(@user)
  end

  def send message
    prepare_message(message).save
  end

  def send! message
    prepare_message(message).save!
  end

  def receiver
    case @reach
      when :organization
        Organization.where(id: @receiver_id)
      else
        nil
    end
  end

  def clear_notifications
    Ringbell::Notification.where(notifiable_type: 'Im::Message', notifiable_id: unread_messages.map(&:id), user_id: @user.id).destroy_all

    PrivatePub.publish_to "/messages/private/#{@user.id}", {clear_notifications: true}
  end

private
  def prepare_message message
    case @reach
      when :broadcast
        build_broadcast_message message
      when :organization
        build_organizations_message message
      else
        raise RuntimeError
    end
  end

  def build_broadcast_message(message)
    message.sender_user_id = @user.id
    message.reach = :broadcast
    message
  end
  
  def build_organizations_message(message)
    message.reach = :organization
    message.sender_user_id = @user.id
    message.sender_id = @sender_id
    message.receiver_id = @receiver_id
    message
  end
end
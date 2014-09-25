class Im::OrganizationMediator

  def initialize(template=nil, context=nil, dialogue=nil)
    @dialogue = dialogue
    @template = template
    @controller = context
  end

  # вебсокет сообщение об измененных сообщениях
  def publish_messages_changes
    PrivatePub.publish_to "/messages/organization/#{@dialogue.receiver_id}", notifications: { count: 0 }
    PrivatePub.publish_to "/messages/organization/#{@dialogue.sender_id}", notifications: { count: 0 }
  end

end
module NotificationEngine
  class PrivatePub
    def self.notify user, message, options
      ::PrivatePub.publish_to "/messages/private/#{user.id}", {notification: {name: message.receiver_type, diff: 1, module: 'messages'}, message: message}
    end
  end
end
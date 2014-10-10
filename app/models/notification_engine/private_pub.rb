module NotificationEngine
  class PrivatePub
    def self.notify user, message, options
      channel = "/messages/private/#{user.id}"
      Rails.logger.info '---------------'
      Rails.logger.info "send notification about message through Websocket to #{channel}"
      Rails.logger.info '---------------'
      ::PrivatePub.publish_to channel, {notification: {name: message.receiver_name, diff: 1, module: 'messages'}, message: message}
    end
  end
end
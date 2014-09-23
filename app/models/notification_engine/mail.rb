module NotificationEngine
  class Mail
    def self.notify user, message, options
      NotificationMailer.delay.notify(user.email, message.text)
    end
  end
end
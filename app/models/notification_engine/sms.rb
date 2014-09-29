module NotificationEngine
  class Sms
    def self.notify user, message, options
      unless user.cell_phone_number.nil? || user.cell_phone_number.empty?
        Im::SmsPresenter.send_message user.cell_phone_number, URI.encode(message.text)
      end
    end
  end
end
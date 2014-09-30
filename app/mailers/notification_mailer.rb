class NotificationMailer < ActionMailer::Base
  default from: "sake@cyclonelabs.net"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.notify.subject
  #
  def notify(email, message)
    @message = message

    mail(to: email) unless email.blank?
  end
end

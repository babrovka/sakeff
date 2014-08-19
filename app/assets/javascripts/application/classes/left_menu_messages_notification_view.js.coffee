# Identify how many unread messages an user has
# @note uses this data parameter "unread_messages_amount":
#   {unread_messages_amount: 5}

class window.app.LeftMenuMessagesNotificationView extends window.app.NotificationModel
  did_recieve_message: (data) ->
    unless _.isEmpty(data)
      element = $(".js-left-menu-notification-icon-messages")

      # Css class for text color
      status_class = "badge badge-green"

      # Updates text value and visual style
      element.addClass(status_class)
             .effect('highlight')
             .text(data.unread_messages_amount)

# Handles status change of objects in left user menu
# @note uses this data structure:
#   [{:spunObject => {status_text: "Атака инопланетян", status_type: "плохо"}},
#    {:kzsObject => {status_text: "Рождение единорогов", status_type: "хорошо"}}]
# @see control/dashboard#activate
class window.app.LeftMenuMessagesNotificationView extends window.app.NotificationModel
  did_recieve_message: (data) ->
    console.log data
    element = $(".js-left-menu-messages > a > .badge")

    # Css class for text color
    status_class = "badge badge-green"

    # Updates text value and visual style
    element.addClass(status_class)
           .effect('highlight')
           .text(data.unread_messages_amount)

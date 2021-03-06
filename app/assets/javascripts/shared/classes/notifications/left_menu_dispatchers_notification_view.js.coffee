# Handles status change of objects in left user menu
# @note uses this data structure:
#   [{:spunObject => {status_text: "Атака инопланетян", status_type: "плохо"}},
#    {:kzsObject => {status_text: "Рождение единорогов", status_type: "хорошо"}}]
# @see control/dashboard#activate
class window.app.LeftMenuDispatchersNotificationView extends window.app.NotificationModel
  did_recieve_message: (data) ->
    for status in data.statuses
      do ->
        for id,values of status
          element = $(".js-left-menu-notification-icon-dispatcher")

          # Css class for text color
          status_class = switch values["status_type"]
            when "alarm" then "badge-red"
            else "badge-green"

          # Updates text value and visual style
          element.removeClass("badge-green badge-red")
                 .addClass(status_class)
                 .effect('highlight')
                 .text(" ")
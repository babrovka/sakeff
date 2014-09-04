# Handles status change of objects in dashboard
# @note uses this data structure:
#   [{:spunObject => {status_text: "Атака инопланетян", status_type: "плохо"}},
#    {:kzsObject => {status_text: "Рождение единорогов", status_type: "хорошо"}}]
# @see control/dashboard#activate
class window.app.UsersDashboardNotificationView extends window.app.NotificationModel
  did_recieve_message: (data) ->
    for status in data.statuses
      do ->
        for id,values of status
          element = $("#" + id)

          # Css class for text color
          status_class = switch values["status_type"]
            when "alarm" then "text-red"
            else "text-green"

          # Updates text value and visual style
          element.find(".js-status-type")
                 .removeClass("text-green text-red")
                 .addClass(status_class)
                 .text(values["status_text"])
                 .effect('highlight')
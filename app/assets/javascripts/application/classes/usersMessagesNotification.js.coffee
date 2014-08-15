# Handles status change of objects in dashboard
# @note uses this data structure:
#   [{:spunObject => {status_text: "Атака инопланетян", status_type: "плохо"}},
#    {:kzsObject => {status_text: "Рождение единорогов", status_type: "хорошо"}}]
# @see control/dashboard#activate
class window.app.usersMessagesNotificationView extends window.app.NotificationModel
#  getData: () ->

  did_recieve_message: (data) ->
    console.log data


#    location.reload()
# @note
#     Класс для управления нотификациями извне
#     Подписывается на PrivatePub и дает команды вьюхе
class window.app.LeftMenuNotificationsController extends window.app.NotificationModel

  _custom_constructor: ->
    console.log @.channel if @.debug
    @.notificationView = new window.app.LeftMenuNotificationsView()


  did_recieve_message : (data, channel) ->
    @.notificationView.syncNotifications()
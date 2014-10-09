class window.app.widgets.ImNotification extends window.app.NotificationModel

  did_recieve_message: (data) ->
    models.broadcast.fetch()

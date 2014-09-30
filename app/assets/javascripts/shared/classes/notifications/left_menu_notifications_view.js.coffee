class @.app.LeftMenuNotificationsView

  params:
    container: '.js-left-menu'

  constructor: ->
    @.$container = $(@.params.container)

    window.models.notifications.fetch()
    window.models.notifications.on('sync',  =>
      @.notifications = window.models.notifications
      @._initComponent()
    )



  _initComponent: ->
    _.each @.notifications.models, (el) =>
      count = @.calculateCountFor(el)
      @.renderNotification(el.module, el.name, count)




  calculateCountFor: (notification) ->
    count = 0

    if notification.type == 'broadcast'
      notifications_to_calculate = @.notifications.where(module: notification.module)
      _.each notifications_to_calculate, (el) ->
        count += el.count

    else
      count = notification.count

    count




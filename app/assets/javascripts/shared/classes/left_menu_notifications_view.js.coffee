# @note
#     Класс рисующий все баблы в левом меню в интерфейсе
#     Сам синхронизирует коллекцию с сервером и считает количество нотификаций по подпунктам
class @.app.LeftMenuNotificationsView

  params:
    container: '.js-left-menu'

  constructor: ->
    @.$container = $(@.params.container)
    if _.isNaN(window.models.notifications) || _.isUndefined(window.models.notifications)
      throw new TypeError("для работы необходима модель Notifications #{JSON.stringify(window.models.notifications)}")
    @.syncNotifications()

  # @note полная синхронизация и перерисовка нотификаций между сервером и клиентом
  syncNotifications: ->
    window.models.notifications.fetch()
    window.models.notifications.on('sync', =>
      @.notifications = window.models.notifications
      @.renderNotifications()
    )


  # @note рендерим все нотификации, которые есть в локальной копии
  renderNotifications: ->
    if _.isNaN(@.notifications) || _.isUndefined(@.notifications) || @.notifications.length==0
      throw new TypeError("для работы необходимы данные в коллекции notifications #{JSON.stringify(window.models.notifications)}")

    _.each @.notifications.models, (_el) =>
      el = _el.attributes
      @.renderNotification(el.module, el.name, el.count)

    _.each @.globalModulesList(), (module) =>
      count = @.calculateCountForModule module
      @.renderNotification(module, 'all', count)


  # @note достаем список всех модулей, по которым есть нотификации
  globalModulesList: ->
    _.uniq @.notifications.pluck('module')


  # расчет суммарного количества нотификаций для модуля
  calculateCountForModule: (module) ->
    count = 0

    notifications_to_calculate = @.notifications.where(module : module)
    _.each notifications_to_calculate, (el) ->
      new_count = el.attributes.count
      if _.isNaN(new_count) || _.isUndefined(new_count)
        throw new TypeError("кол-во оповещений должно быть числом для элемента #{JSON.stringify(el)}")

      count += new_count

    count

  # рендерим нотификацию
  renderNotification: (module, name, count) ->
    @.$container.find("[data-module='#{module}'][data-name='#{name}'] > a > .js-left-menu-notification-badge").text(count).effect('highlight')
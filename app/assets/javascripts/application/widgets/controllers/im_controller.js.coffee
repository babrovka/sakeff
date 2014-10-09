class window.app.widgets.ImController
  $container : null
  view : null

  constructor : (@$container) ->
    @_initNotification()
    @_renderView()


  _fetchData : =>
    models.broadcast.fetch()


  _bindModels : =>
    models.broadcast.on('sync', (_method, models) =>
      throw new Error('ошибка в создании класса Представления') if _.isUndefined(@view) || _.isNull(@view)
      console.log window.models.broadcast.models
      @view.setState({messages: window.models.broadcast.models})
    )

  _viewInitHandler: =>
    @_bindModels()
    @_fetchData()

  _renderView: ->
    throw new Error('контейнер под отрисовку виджета отсутствует') unless @$container.length
    @view = React.renderComponent(
      window.app.widgets.ImView(componentDidMountCallback : @_viewInitHandler),
      @$container[0]
    )

  _initNotification: ->
    # т.к.нотификации мне самому не приходят,
    # а нужно обновлять сообщения,
    # то я подписываюсь на каналы организаций и броадкста,
    # чтобы воспользоаться тем-же каналом доставки сообщений,
    # что и в полноценных модулях
    @.notification = new app.widgets.ImNotification("/messages/broadcast", debug: false)
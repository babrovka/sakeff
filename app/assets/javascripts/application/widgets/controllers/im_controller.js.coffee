class window.app.widgets.ImController
  $container : null
  view : null
  messages : null
  dialogues : null

  constructor : (@$container) ->
    throw new Error('Нет контейнера для отрисовки виджета') if _.isUndefined(@$container[0]) || _.isNull(@$container[0])
    @_enableNotification()
    @_initView()


  # инициализируем вьюху
  _initView: ->
    # рисуем виджет только после того, как получим список диалогов
    # выполняем один раз, принудительно ограничиваем обновление диалогов в один раз
    throw new Error('контейнер под отрисовку виджета отсутствует') unless @$container.length

    # рендерим вьюху сразу, потому что это никак не зависит от прав
    @view = React.renderComponent(
      window.app.widgets.ImView(
        changeSelectedDialogue : @_changeSelectedDialogueHandler
      ),
      @$container[0]
    )


    if app.CurrentUser.hasPermission('read_broadcast_messages')
      selected = window.models.broadcastDialogue
      @view.setState(dialogues : [selected])
      # устанавливаем по умолчанию циркуляр после отрисовки плагина
      @_changeSelectedDialogueHandler(selected.receiver_id)

    if app.CurrentUser.hasPermission('read_organization_messages')
      models.dialogues.on 'sync', (_method, dialogues) =>
        # первым ставим в списке Циркуляр,чтобы он первый был в ниспадающем списке
        # но только при наличии соответствующего права
        dialogues.unshift window.models.broadcastDialogue if app.CurrentUser.hasPermission('read_broadcast_messages')

        # рендерим вьюху по полученным с сервера диалогам
        selected  = dialogues[0]
        @view.setState(dialogues : dialogues)
        @_changeSelectedDialogueHandler(selected.receiver_id)

      models.dialogues.fetch()

  # обрабатываем переключение диалогов
  # принудительно используем = вместо - в объявлении метода
  # чтобы прокинуть данный класс внутрь метода
  # в тот момент, как этот метод являетс колбеком другого класса
  _changeSelectedDialogueHandler: (dialogue_id) =>
    dialogue =  if dialogue_id=='broadcast'
                  window.models.broadcastDialogue
                else
                  _d = window.models.dialogues.findWhere(receiver_id: dialogue_id)
                  window.models.organizationDialogue.url = _d.attributes.api_path
                  window.models.organizationDialogue.receiver_id = _d.attributes.receiver_id
                  window.models.organizationDialogue.send_message_path = _d.attributes.send_message_path
                  window.models.organizationDialogue
    if dialogue
      @_selectDialogueInView(dialogue)
      @_fetchDialogueMessages(dialogue)
      @_enableNotification()


  # выставляем вьюхе какой диалог был выбран
  # это решает не вьюха, потому что контроллер
  # патчит диалоги и решает область видимости
  _selectDialogueInView: (dialogue) ->
    if dialogue && dialogue.receiver_id == 'broadcast' && app.CurrentUser.hasPermission('send_broadcast_messages')
      @view.setState(selected: dialogue)
    else if !!dialogue && app.CurrentUser.hasPermission('send_organization_messages')
      @view.setState(selected : dialogue)
    else
      @view.setState(selected : null)

  # скачиваем данные для диалога
  # в качестве аргумента передаем нужный диалог
  # перед скачиванием умно подписываемся на их изменение
  _fetchDialogueMessages: (dialogue) ->
    if @selected_dialogue && _.isFunction(@selected_dialogue.off)
      @.selected_dialogue.off 'sync'
    @.selected_dialogue = dialogue
    @.selected_dialogue.on 'sync', (__method, models) =>
      throw new Error('ошибка в создании класса Представления') if _.isUndefined(@view) || _.isNull(@view)
      @view.setState(messages : @.selected_dialogue.models)

    @selected_dialogue.fetch()

  # активируем нотификации через вебсокеты и колбеки по ним
  # т.к.виджет реагирует только на открытый диалог
  # то приходится удалять текущую нотификацию и создавать новую
  _enableNotification: ->
    # т.к.нотификации мне самому не приходят,
    # а нужно обновлять сообщения,
    # то я подписываюсь на каналы организаций и броадкста,
    # чтобы воспользоаться тем-же каналом доставки сообщений,
    # что и в полноценных модулях
    if !!@selected_dialogue && _.isFunction(@selected_dialogue.transport_url)
      @notification.remove() if !!@notification
      delete @.notification
      @.notification = new app.widgets.ImNotification(@selected_dialogue.transport_url(), { debug: false }, @selected_dialogue)
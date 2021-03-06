### класс-модель обертка над PrivatePub
  главным образом нужен для двух целей
  1. не писать методы PrivatePub в виде колбека на колбек.
  2. чтобы множество колбэков на один канал обрабатывались

  КАКИЕ МЕТОДЫ ПРИНИМАЕТ
  channel — первый параметр конструктора, String тип, имя канала, обязательно должно начинаться со знака |
  params - второй параметр, Object тип

  в params можно передать debug: true, чтобы выводить в консоли внутренние сообщения разработчика


  КАК РАБОТАТЬ С КЛАССОМ
  для работы нужно создать свой класс
    class window.app.WebsocketCounterNotificationView extends window.app.NotificationModel

  и переопределить работу метода
    did_recieve_message: (data, channel) ->


  ВАЖНО
  Все отнаследованные классы от данного класса занесутся в список колбэков,
  которые будут выполняться при получении сообщения в их общий канал.

  Это приводит к возможности создать два класса-вьюхи с разным интерфейсом
  и подписать их на один канал.


###
class window.app.NotificationModel

  debug: false

  constructor : (channel, new_params={}, custom_params={}) ->
    # делаем однотипные имена каналов
    # на входе /messages/broadcast/ или /messages/broadcast
    # но получаем всегда /messages/broadcast
    @channel = channel.replace(/\/$/, '')
    _.extend(@, new_params)
#    @channel = channel

    # добавляем себя в коллекцию колбеков
    window.app.NotificationsCallbacks.add_view(@channel, @)

    # инициализируем PrivatePub
    @._initial_private_pub()

    @._custom_constructor(custom_params)
    @

  #
  did_recieve_message: (data, channel) ->
    console.log data
    console.log channel

    @

  # удаляем текущий класс нотификаций
  # убираем из колбеков
  # удаляем себя памяти
  remove: ->
    number_in_callbacks = window.app.NotificationsCallbacks[@channel].indexOf(@)
    window.app.NotificationsCallbacks[@channel].splice(number_in_callbacks, 1)

  # private zone
  _initial_private_pub: ->
    PrivatePub.subscribe(@.channel, (data, channel) =>
      console.log "did recieve message for channel #{@.channel} in #{@.constructor.name}" if @.debug
      for _view in window.app.NotificationsCallbacks[channel]
        _view.did_recieve_message(data, channel)
    )
    console.log "subscribed on '#{@.channel}' in #{@.constructor.name}" if @.debug

    @

  _custom_constructor: (custom_params) ->
    @



###
  Сборщик колбэков всех классов-вьюх для нотификаций через PrivatePub
  Напрямую лучше нигде не использовать.

  Данный сборщик нужен для того, чтобы на один PrivatePub канал было создано много вьюх
  И каждый из колбэков этих вьюх отрабатывал отрисовку

  По умолчанию PrivatePub подписывает на события так, что работает только последний колбэк
  А это означает, что вызвав несколько разных классов вьюх на один канал
  мы получим работающим только последний
###

window.app.NotificationsCallbacks ||= {}
window.app.NotificationsCallbacks.add_view = (channel, class_view) ->
  @[channel] ||= []
  @[channel].push(class_view)

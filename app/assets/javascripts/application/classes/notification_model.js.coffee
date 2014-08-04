### класс-модель обертка над PrivatePub
  главным образом нужен для того, чтобы
  не писать соединение с каналом каждый раз

  КАКИЕ МЕТОДЫ ПРИНИМАЕТ
  channel — первый параметр конструктора, String тип, имя канала, обязательно должно начинаться со знака |
  params - второй параметр, Object тип

  в params можно передать debug: true, чтобы выводить в консоли внутренние сообщения разработчика


  КАК РАБОТАТЬ С КЛАССОМ
  для работы нужно создать свой класс
    class window.app.WebsocketCounterNotificationView extends window.app.NotificationModel

  и переопределить работу метода
    did_recieve_message: (data, channel) ->


  ОСТОРОЖНО
  PrivatePub подписывает на события так, что работает только последний колбэк
  А это означает, что вызвав несколько разных классов вьюх на один канал
  мы получим работающим только последний
  На данный момент это ограничение PrivatePub и решаться не планируется


###
class window.app.NotificationModel

  params:
    debug: false

  constructor : (channel, new_params) ->
    @.params = _.extend(@.params, new_params)
    @.params.channel = channel

    @._initial_private_pub()

    @

  #
  did_recieve_message: (data, channel) ->
    console.log data
    console.log channel

    @


  # private zone
  _initial_private_pub: ->
    @.params.channel ||= "/broadcast/test_channel"
    PrivatePub.subscribe(@.params.channel, (data, channel) =>
      console.log 'did recieve message' if @.params.debug
      @.did_recieve_message(data, channel)
    )
    console.log "subscribed on '#{@.params.channel}' channel" if @.params.debug

    @


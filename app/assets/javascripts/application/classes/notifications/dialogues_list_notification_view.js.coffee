# Класс для отображения новых сообщений
class window.app.DialogiesListNotificationView extends window.app.NotificationModel

  params:
    url: '/dialogues.js'

  _custom_constructor: ->
    console.log 'inited'


  did_recieve_message: (data) =>
    console.log 'yes'
    @.getNewMessages()


  getNewMessages: () =>
    $.ajaxSetup beforeSend : (xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")

    $.ajax(
      url : @.params.url
      type : 'GET'
      dataType : "script"
    )




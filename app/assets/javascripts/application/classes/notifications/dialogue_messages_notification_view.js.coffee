# Класс для отображения новых сообщений
class window.app.DialogueMessagesNotificationView extends window.app.NotificationModel


  _custom_constructor: ->
    console.log @.dialogue_id = gon.dialogue_id

  did_recieve_message: (data) =>
    @.getDialogueMessages()


  getDialogueMessages: () =>
    $.ajaxSetup beforeSend : (xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")

    $.ajax(
      url : "/dialogues/#{@.dialogue_id}/messages/unread.js"
      type : 'GET'
      dataType : 'script'
    )




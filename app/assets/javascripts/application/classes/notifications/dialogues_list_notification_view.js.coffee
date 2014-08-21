# Класс для отображения новых сообщений
class window.app.DialoguesListNotificationView extends window.app.NotificationModel

  params:
    url: '/dialogues.js'

  did_recieve_message: (data) =>
    @.getAllDialogues()


  getAllDialogues: () =>
    $.ajaxSetup beforeSend : (xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")

    $.ajax(
      url : @.params.url
      type : 'GET'
      dataType : "script"
    )




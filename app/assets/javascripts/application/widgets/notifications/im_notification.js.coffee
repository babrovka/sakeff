class window.app.widgets.ImNotification extends window.app.NotificationModel

  _custom_constructor: (@selected_dialogue) ->
    console.log 'выбран для обновления диалог ', @selected_dialogue if @debug

  did_recieve_message: (data) ->
    if !!@selected_dialogue
      console.log 'Обновляем сообщения для диалога', @selected_dialogue if @debug
      @selected_dialogue.fetch()

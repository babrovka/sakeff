$ ->
  $('.js-select2').select2(global.select2)
  $('select.js-select2-nosearch').select2(global.select2_nosearch)

  $(document).checkboxes_and_radio()


  # нотификации главного меню
  new window.app.LeftMenuDispatchersNotificationView("/broadcast/control")
  new window.app.LeftMenuMessagesNotificationView("/messages/broadcast")
  new window.app.LeftMenuUnitsNotificationView("/broadcast/unit/bubble/change")

#    new window.app.UsersDashboardNotificationView("/broadcast/control")



  # клики по кнопкам «очистить» к формам
  # на момент написания встречается в форме сообщений
  $('.js-erasable-form-action').on('click', (e) ->
    e.preventDefault()
    $(e.target).closest('.js-erasable-form')
                .find('input, select, textarea')
                .not('input[type=submit], input[type=button]')
                .val('')
  )
  # активизация сабмита формы через ctrl+enter или command+enter
  $('form').ctrlEnterFormSubmitter()



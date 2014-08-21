window.app = {}
window.global =
  chosen:
    disable_search_threshold: 1
    no_results_text: "Ничего не найдено."
    placeholder_text_multiple: " "
    placeholder_text_single: " "
    disable_search: true
    display_selected_options: false
    search_contains: true

  chosen_search:
    disable_search_threshold: 1
    no_results_text: "Ничего не найдено."
    placeholder_text_multiple: " "
    placeholder_text_single: " "
    display_selected_options: false
    search_contains: true

  datepicker:
    showOtherMonths: true
    dateFormat: "dd.mm.yy"
    # убираем это свойство,потому что из-за него нельзя выбрать дату ранее сегодня в фильтрах по дате
    # minDate: new Date()

  icheck:
    checkboxClass: 'icheckbox_flat-green checkbox-inline'
    radioClass: 'iradio_flat-green radio-inline'
    disabledClass: 'js-ichecked-input'

  sendRequest: (url, type, protect, data) ->

    if protect
      $.ajaxSetup beforeSend: (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

    $.ajax(
      url: url
      type: type
      dataType: "json"
      data: (if type=='POST' then {'data': data} else '')
    )


$ ->
  window.prettyPrint and prettyPrint()

  $('.js-select2').select2()
  $('select.js-select2-nosearch').select2(
    minimumResultsForSearch: -1
  )

  @

  $(document).checkboxes_and_radio()



  #взять айди
  uuid = document.getElementsByClassName('js-uuid')[0].innerHTML


  new window.app.LeftMenuMessagesNotificationView("/private/messages/"+uuid, {debug: false})
  new window.app.DialoguesListNotificationView("/private/messages/"+uuid, {debug: true})
  new window.app.DialogueMessagesNotificationView("/private/messages/" + uuid)

  # нотификации главного меню
  # new window.app.LeftMenuMessagesNotificationView("/broadcast/messages/"+uuid)
  new window.app.LeftMenuDispatchersNotificationView("/broadcast/control")

  #заглушка для сообщений в левом меню при загрузке
#  $(".js-left-menu-messages > a > .badge").text "5"
#  $(".js-left-menu-messages > a > .badge").addClass "badge-green"

  #блокировка выбора пользователей при нажатой галке"выбрать всех"

  $('.js-send-to-all').click ->
    if this.checked
      $(".js-select-recipients").select2 "enable", false
    else
      $(".js-select-recipients").select2 "enable", true


  if $('._messages-page').length > 0
    new window.app.UsersMessagesNotificationView("/broadcast/messages/"+uuid)

  if $("._dashboard-page").length > 0
    new window.app.usersDashboardNotificationView("/broadcast/control")



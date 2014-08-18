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
  window.app.topOnLoad = $("ul._left-menu").offset().top
  window.prettyPrint and prettyPrint()

  $('.js-select2').select2()
  $('select.js-select2-nosearch').select2(
    minimumResultsForSearch: -1
  )

  @

  $(document).checkboxes_and_radio()

  # Turns on notifications

  if $("._dashboard-page").length > 0
    dashboardNotification = new window.app.usersDashboardNotificationView("/broadcast/control", {debug: false})

  if $(".js-dashboard-menu").length > 0
    menuNotification = new window.app.usersMenuNotificationView("/broadcast/control", {debug: false})


  #взять айди
  uuid = document.getElementsByClassName('js-uuid')[0].innerHTML
  messagesNotification = new window.app.LeftMenuMessagesNotificationView("/broadcast/messages/"+uuid, {debug: false})

  #заглушка для сообщений в левом меню при загрузке
  $(".js-left-menu-messages > a > .badge").text "5"
  $(".js-left-menu-messages > a > .badge").addClass "badge-green"

  if $('._messages-page').length > 0
    messagesNotification = new window.app.UsersMessagesNotificationView("/broadcast/messages/"+uuid, {debug: true})
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


  $(document).checkboxes_and_radio()



  #взять айди
  uuid = document.getElementsByClassName('js-uuid')[0].innerHTML


  # нотификации главного меню
  new window.app.LeftMenuDispatchersNotificationView("/broadcast/control")
  new window.app.LeftMenuMessagesNotificationView("/messages/broadcast")

  #заглушка для сообщений в левом меню при загрузке
#  $(".js-left-menu-messages > a > .badge").text "5"
#  $(".js-left-menu-messages > a > .badge").addClass "badge-green"

  #блокировка выбора пользователей при нажатой галке"выбрать всех"
#  $('.js-send-to-all').click ->
#    if this.checked
#      $(".js-select-recipients").select2 "enable", false
#    else
#      $(".js-select-recipients").select2 "enable", true


  if $("._dashboard-page").length > 0
    new window.app.UsersDashboardNotificationView("/broadcast/control")



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


  # делаем так, чтобы форма сообщения не скролилась при прокрутке сообщений
  $element = $(".js-not-scrollable-elem")
  if $element.length
    elem_width = $element.outerWidth()
    topOnLoad = $element.offset().top
    $(window).scroll ->
      if topOnLoad <= $(window).scrollTop()
        $element.css
          position : "fixed"
          top : 0
          'padding-top': '20px'
          width: elem_width
          'z-index': 1
          'box-shadow': '0 10px 10px -10px black'
      else
        $element.css
          position : "relative"
          top : ""
          'box-shadow': 'none'
          'padding-top' : 0
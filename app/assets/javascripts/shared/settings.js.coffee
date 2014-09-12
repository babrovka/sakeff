window.global ||= {}
window.global =
#  chosen :
#    disable_search_threshold : 1
#    no_results_text : "Ничего не найдено."
#    placeholder_text_multiple : " "
#    placeholder_text_single : " "
#    disable_search : true
#    display_selected_options : false
#    search_contains : true
#
#  chosen_search :
#    disable_search_threshold : 1
#    no_results_text : "Ничего не найдено."
#    placeholder_text_multiple : " "
#    placeholder_text_single : " "
#    display_selected_options : false
#    search_contains : true

  select2:
    width : 'off'

  select2_nosearch:
    minimumResultsForSearch : -1

  datepicker :
    showOtherMonths : true
    dateFormat : "dd.mm.yy"
# убираем это свойство,потому что из-за него нельзя выбрать дату ранее сегодня в фильтрах по дате
# minDate: new Date()

  icheck :
    checkboxClass : 'icheckbox_flat-green checkbox-inline'
    radioClass : 'iradio_flat-green radio-inline'
    disabledClass : 'js-ichecked-input'

  sendRequest : (url, type, protect, data) ->
    if protect
      $.ajaxSetup beforeSend : (xhr) ->
        xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content")
        return

    $.ajax(
      url : url
      type : type
      dataType : "json"
      data : (if type == 'POST' then {'data' : data} else '')
    )


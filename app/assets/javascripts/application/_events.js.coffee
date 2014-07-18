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

$ ->
  window.prettyPrint and prettyPrint()

  $('.js-select2').select2()
  $('select.js-select2-nosearch').select2(
    minimumResultsForSearch: -1
  )

  @

  $(document).checkboxes_and_radio()


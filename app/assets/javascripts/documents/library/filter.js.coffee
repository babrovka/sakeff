# Модальное окно с фильтрацией по документам
$ ->
  window.app.filter =
    modal:
      container: '.js-document-filter-modal'
    filter_form: '.js-filter-form'
    add_btn: '.js-filter-add-row-btn'
    remove_row_btn: '.js-filter-row-remove-btn'
    default_row_source: '.js-filter-option-row-source'
    query_source: '.js-filter-row-query-source'
    filter_container: '.js-filter-container'
    query_row_container: '.js-filter-row'
    query_container: '.js-filter-query'
    attribute_select: '.js-filter-attribute'


  F = app.filter

  # закрываем инпуты, чтобы они не передавались на сервер
#  $("#{app.default_row_source} input, #{F.default_row_source} select").prop('disabled', 'disabled')
  $(F.default_row_source).find('input, select').prop('disabled', 'disabled')
  $(F.query_source).find('input, select').prop('disabled', 'disabled')


  # search filter
  # by timeout updating search result count
  timer_id = 0
  $(document).on('keyup blur change', F.filter_form, ->
    clearTimeout(timer_id)
    timer_id = setTimeout( ->
      data = $(F.filter_form).serializeArray()
      $.ajax
        data: data
        dataType: 'script'
        type: 'POST'
        url: $(F.filter_form).data('url')

    , 200)
  )

  # делаем действия каждый раз,когда форма фильтра обновляется
  $(document).on('filter:update', ->
    $(".js-datepicker").not('hasDatepicker').filter(':visible').datepicker(global.datepicker)

    # всем инпутам и селектам выставляем свойство disabled, чтобы не отправлять лишнее на сервер
    $("#{F.filter_container} input,  #{ F.filter_container} select").prop('disabled', '')

    $( ".js-chosen" ).filter(':visible').chosen(global.chosen)
  )

  # добавляем новую строку с выбором «атрибута поиска» и самим поисковым полем
  $(document).on('click', F.add_btn, ->
    # html-template должен быть обернут в js класс со словом source, сам этот класс не переносится, а вставляется только его содержимое
    $(@).before($(F.default_row_source).html())
    $(F.filter_form).trigger('filter:update')
  )

  # удаляем текущую строку с параметрами фильтрации
  $(document).on('click', F.remove_row_btn, ->
    $(@).closest(F.query_row_container).empty()
  )

  # меняем имя стринга так, чтобы отправлять на сервер для поиска отправлялось с префиксом из селекта
  $(document).on('change', "#{F.filter_container} #{F.query_container} select", ->
    $elem = $(@)
    $query_container = $elem.closest(F.query_container)
    $input = $query_container.find('input')

    input_name = "q[#{$input.data('name')}_#{$elem.val()}]"
    $input.prop('name', input_name)

    $(F.filter_form).trigger('filter:update')
  )

  # выбираем новый атрибут поиска «дата» или «название»
  # и заменяем текущую строку с инпутом на подходящую
  $(document).on('change', "#{F.filter_container} #{F.attribute_select}", ->
    $elem = $(@)
    $query_container = $elem.closest(F.query_row_container).find(F.query_container)
    $new_query_html = $("#{F.query_source}[data-type='#{$elem.val()}']").html()

    $query_container.html($new_query_html)
    $(F.filter_form).trigger('filter:update')
  )

  # обрабатываем клики на стилизованных чекбоксах
  $(document).on('ifChanged', "#{F.filter_container} input[type=checkbox]", ->
    $(F.filter_form).trigger('filter:update')
  )

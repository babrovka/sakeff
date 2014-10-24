## Переопределяем работу jquery-ujs связанную с атрибутом data-confirm у ссылок
#
## обертка для работы с собственными модальными окнами подтверждений
#myCustomConfirmBox = (element, message, callback) ->
#  modal = new ModalWindowView(
#                              theme: element.data('type')
#                              confirm_txt: element.data('agree-txt')
#                              )
#  modal.confirm message, callback
#  modal.destroy
#  return
#
#
#
## вызываем кастомное модальное окно при подветржении data-confirm
## https://github.com/rails/jquery-ujs/blob/master/src/rails.js#L242
#$.rails.allowAction = (element) ->
#  message = element.data("confirm")
#  answer = false
#  callback = undefined
#  return true  unless message
#  if $.rails.fire(element, "confirm")
#    myCustomConfirmBox element, message, ->
#      callback = $.rails.fire(element, "confirm:complete", [answer])
#      if callback
#        oldAllowAction = $.rails.allowAction
#        # выставляем в true, чтобы при погружении внутрь события пройти валидации события (linkClickSelector, click.rails)
#        $.rails.allowAction = ->
#          true
#        # вызываем событие и погружаемся внутрь ujs
#        element.trigger 'click.rails'
#        # восстанавливаем работу метода
#        $.rails.allowAction = oldAllowAction
#      return
#
#  false
#
## переходим по ссылке, которая объявлена в ссылке
#$.rails.handleLink = (element) ->
#  window.location = $.rails.href(element)
#  false
#
#$ ->
#  # выключаем события ujs по умолчанию
#  $(document).off('click.rails', $.rails.linkClickSelector)
#
#  # переопределяем события клика по кнопке
#  # https://github.com/rails/jquery-ujs/blob/master/src/rails.js#L321
#  #
#  # добавлен переход по ссылке начальной кнопки, если в процессе погружения выясняется,что у кнопки нет ни remote ни method
#  # нужно, чтобы простые кнопки с data-confirm работыли хорошо
#  $(document).delegate $.rails.linkClickSelector, "click.rails", (e) ->
#    link = $(this)
#    method = link.data("method")
#    data = link.data("params")
#    metaClick = e.metaKey or e.ctrlKey
#    return $.rails.stopEverything(e)  unless $.rails.allowAction(link)
#    $.rails.disableElement link  if not metaClick and link.is($.rails.linkDisableSelector)
#    if link.data("remote") isnt `undefined`
#      return true  if metaClick and (not method or method is "GET") and not data
#      handleRemote = $.rails.handleRemote(link)
#
#      # response from rails.handleRemote() will either be false or a deferred object promise.
#      if handleRemote is false
#        $.rails.enableElement link
#      else
#        handleRemote.error ->
#          $.rails.enableElement link
#          return
#
#      false
#    else if link.data("method")
#      $.rails.handleMethod link
#      false
#    # добавленная часть в метод,взятый из исходников ujs
#    else
#      $.rails.handleLink link
#      false
#
#
#
#
#
#

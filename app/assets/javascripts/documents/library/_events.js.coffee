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


# Исполнение js-кода внутри кастомного контекста
window.eval_js_in_context = (data, context) ->
  (->
    eval data
  ).apply context

window.app.enable_welcome = ->
  $('.js-welcome-screen').modal('show')
  $('.modal-backdrop').removeClass().addClass('modal-backdrop-white in')
  if $('.js-welcome-screen').find('.js-screen-user-actions').length > 0
    $(document).one 'click', '.js-screen-exit', (e) ->
      $('.modal, .modal-backdrop-white').fadeOut(1000, -> $(@).modal('hide').remove())
  else
    $('.modal, .modal-backdrop-white').delay(1500).fadeOut(1000, -> $(@).modal('hide').remove())


$ ->

  # active boostrap tooltips
  $(".js-label-hint").tooltip( placement: 'right' )
  $(".js-tooltip").tooltip( placement: 'top' )

  # replace backslashes to nil word.
  # backslashes come from multiple lines slim partials.
  $.each($('.prettyprint'), ->
    $(@).html($(@).html().replace(/\\/g, ''))
  )

  # chosen-search
  $( ".js-chosen-search" ).filter(':visible').chosen( global.chosen_search )
  $( ".js-chosen" ).filter(':visible').chosen( global.chosen )

  # dropdown
  $('.dropdown-toggle').dropdown()

  # datepicker
  $('.js-datepicker').not('.js-deadline').filter(':visible').datepicker(global.datepicker)
  date = $('.js-datepicker.js-deadline').datepicker( "getDate" )
  data_days = $('.js-datepicker.js-deadline').data('days')
  max_date = $('.js-datepicker.js-deadline').datepicker( "option", "maxDate" )
  if data_days || max_date
    opts = _.extend(global.datepicker, minDate: date + data_days, max_date )
    $( '.js-datepicker.js-deadline' ).datepicker(opts)

  # datepicker - for nested form

  $(document).on "nested:fieldAdded", (event) ->
    # this field was just inserted into your form
    field = event.field

    # it's a jQuery object already! Now you can find date input
    dateField = field.find(".js-datepicker")
    # and activate datepicker on it
    dateField.datepicker(opts)
    return

  # events to colorizing input and it icon
  $(document).on('focusin', '.input-group input, .js-input-with-icon', (e) ->
    e.stopPropagation()
    $('.input-group').removeClass('active')
    $(@).parent('.input-group').toggleClass('active')
  )

  $(document).on('focusout', '.input-group input, .js-input-with-icon', (e) ->
    e.stopPropagation()
    $('.input-group').removeClass('active')
  )
  # =========

  # set same width for header and dropdown in .dropdown.header
  # because of .dropdown-menu position is set to absolute, than .dropdown width not equal .dropdown-menu
  # the design requirements is the same width of header and dropdown-menu
  # when .dropdown-menu is hidden, it width is equal 0.
  # than calculate it width, when dropdown-menu will be opening
  (->
    $('.dropdown.header .dropdown-toggle:not("calculated")').on('click.dropdown.data-api', (e) ->
      elem = @
      parent = elem.parentElement
      menu = elem.parentElement.getElementsByClassName('dropdown-menu')[0]

      header_w = elem.offsetWidth
      items_w = menu.offsetWidth

      if items_w > 0
        ws = [header_w, items_w]
        width = _.last(ws.sort())
        elem.style.width = "#{width}px"
        menu.style.width = "#{width}px"
        parent.classList.add('calculated')
    )
  )()

  # Initialize checkboxes by iCheck plugin
  if jQuery.fn.iCheck != undefined
    $('input[type="checkbox"], input[type="radio"], .js-checkbox').not('.js-icheck-off input, .js-icheck-off').iCheck(
      global.icheck
    )


  # custom initialize popover
  $('.js-document-state-link').on('click', ->
    $('.js-document-state-link').popover('destroy').filter(@).popover(html: true, animation: false).popover('show').trigger('document_state:show')
  )

  # set strong 'height' and 'width' for popover wrapper
  $('.js-document-state-link').on('document_state:show', ->
    popover = $(@).next().find('.js-document-state-popover')
    popover.css('height': popover.height(), width: popover.width() )
  )


  # AJAX Form-Submit



  $(document).on('ifChecked ifUnchecked', ".js-form-submit", (e) ->
    $(e.target).closest('form').submit()
    )
#    return
  # CLEAR PAGE

  $(document).click (e) ->

    return if $(e.target).closest('.js-popover-content').length || $(e.target).closest('.js-popover').length
#    clearPopover()

    # останавливало весь код.
    # поэтому закомментировал
    # event.stopPropagation()
    return


  # POPOVER !!!
  clearPopover = () ->
    $('.js-popover-content').hide()
    $('.cloned').remove()
    return

  missClick = ->
    yourClick = true
    $(document).bind "click", (e) ->
      if not yourClick and $(e.target).closest('.cloned').length is 0
        $('.cloned').remove()
        $('.js-popover').removeClass('active')
        $(document).unbind('click');
      yourClick = false
      return
    return

  $('.js-popover').on('click', (e) ->
    clearPopover()
    e.preventDefault()
    target = @.dataset.target
    $sourcePopover = $('.js-popover-content[data-target=' + target + ']')
    $sourcePopover.clone(true).appendTo(document.body).addClass('cloned')
    missClick()

    $(@).toggleClass('active')

    if $(@).hasClass('active')
      $('.js-popover').not($(@)).removeClass('active')
      $('.cloned').show().css
        width: "550px"
      $sourcePopover.hide()

    else
      $('.cloned').remove()


    popoverClone = $(".js-popover-content.cloned")
    activeBtnHeight = $(@).outerHeight()
    activeBtnWidth = $(@).outerWidth()
    activeBtnOffset = $(@).offset()
    popoverCloneOffset = popoverClone.offset()
    popoverHeight = popoverClone.outerHeight()
    popoverWidth = popoverClone.outerWidth()
    currentTop = activeBtnOffset.top
    currentLeft = activeBtnOffset.left
    docHeight = $(document).outerHeight()
    docWidth = $(document).outerWidth()

    offset = popoverClone.offset()
    vert = 0.5 * docHeight - currentTop
    vertBalance = docHeight - currentTop
    vertPlacement = (if vert > 0 then "bottom" else  "top")

    horiz = 0.5 * docWidth - currentLeft
    horizBalance = docWidth - currentLeft
    horizPlacement = (if horiz > 0 then "right" else "left")

    aslantPlacement = (
      if currentLeft > horizBalance and currentTop > vertBalance
        "top-left"
      else if currentLeft > horizBalance and currentTop < vertBalance
        "bottom-left"
      else if currentLeft < horizBalance and currentTop > vertBalance
        "top-right"
      else
        "bottom-right"
    )

    placement = (
      if docHeight - (popoverCloneOffset.top + popoverHeight) < 0 || docHeight - (vertBalance + popoverHeight) < 0 || docWidth - (popoverCloneOffset.left + popoverWidth) < 0 || docWidth - (horizBalance + popoverWidth) < 0
        aslantPlacement
      else
        if Math.abs(horiz) > Math.abs(vert)
          horizPlacement
        else
          vertPlacement
    )
    #положение можно задать напрямую в placement = "right" например
    popoverClone.addClass(placement)

    #arrow position formula
    balancePopoverWidth = popoverWidth - activeBtnWidth
    arrowPosRight = balancePopoverWidth + activeBtnWidth/2
    arrowPosLeft = popoverWidth - balancePopoverWidth - activeBtnWidth/2

    if popoverClone.hasClass('bottom')
      popoverClone.css
        top:  currentTop + activeBtnHeight + "px"
        left: (currentLeft + activeBtnWidth/2) - popoverWidth/2  + "px"
    else if popoverClone.hasClass('top')
      popoverClone.css
        top:  currentTop - popoverHeight + "px"
        left: (currentLeft + activeBtnWidth/2) - popoverWidth/2  + "px"
    else if popoverClone.hasClass('right')
      popoverClone.css
        top:  currentTop - popoverHeight/2 + activeBtnHeight/2 + "px"
        left: currentLeft + activeBtnWidth + activeBtnHeight/2 + "px"
    else if popoverClone.hasClass('left')
      popoverClone.css
        top:  currentTop - popoverHeight/2 + activeBtnHeight/2 + "px"
        left: currentLeft - popoverWidth - activeBtnHeight/2 + "px"
    else if popoverClone.hasClass('bottom-left')
      popoverClone.css
        top:  currentTop + activeBtnHeight + "px"
        left: (currentLeft - popoverWidth) + activeBtnWidth + "px"
      popoverClone.find('.arrow').css
        left: arrowPosRight + "px"
    else if popoverClone.hasClass('bottom-right')
      popoverClone.css
        top:  currentTop + activeBtnHeight + "px"
        left: currentLeft + "px"
      popoverClone.find('.arrow').css
        left: arrowPosLeft + "px"
    else if popoverClone.hasClass('top-left')
      popoverClone.css
        top:  currentTop - popoverHeight + "px"
        left: (currentLeft - popoverWidth) + activeBtnWidth + "px"
      popoverClone.find('.arrow').css
        left: arrowPosRight + "px"
    else if popoverClone.hasClass('top-right')
      popoverClone.css
        top:  currentTop - popoverHeight + "px"
        left: currentLeft + "px"
      popoverClone.find('.arrow').css
        left: arrowPosLeft + "px"

  )

  $('.js-popover-close').on('click', (e) ->
    clearPopover()
  )


  # click on 'back' button
  $(document).on('click', '.js-document-state-back-link', ->
    $(@).closest('.popover').prev().popover('show').trigger('document_state:show')
  )

  # close this 'cancel button' popover
  $(document).on('click', '.js-document-state-close-popover', ->
    $(@).closest('.popover').prev().popover('destroy')
  )

  # initialize styling file attach button with file-title near attach button
  $('.js-filestyle-with-title').filestyle()


  # показываем кол-во голосований в списке документов
  # при наведении курсора мыши
  # данный виджет приправлен стилями в css (смотри html)
  # при наведении курсора, мы пряме один блок и показываем другой.
  # при сбегания курсора, все возвращаем в обычное состояние
  $('.js-document-list-conformation-info').hover( (e) ->
    $(e.currentTarget).closest('.js-document-list-conformation-info').find('.fa').fadeOut(50)
    $(e.currentTarget).closest('.js-document-list-conformation-info').children().not('.fa').removeClass('invisible')
  , (e) ->
    $(e.currentTarget).closest('.js-document-list-conformation-info').children().not('.fa').addClass('invisible')
    $(e.currentTarget).closest('.js-document-list-conformation-info').find('.fa').fadeIn(50)
  )

  # БЛОК АКТИВАЦИИ КЛАССОВ
  user_conform = new ConformingView()




#scroll for gantt page
#  return
$(document).ready ->

  $('.js-tasks-table').on "scroll", (e) ->
    y = $($(this)[0]).scrollTop()
    window.app.GanttView.scrollY(y)
    return

window.app.scrollTable = (y) ->
  $('.js-tasks-table').scrollTop(y)

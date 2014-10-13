jQuery ->
  $('.nav-tabs a[href="#licenses"]').on 'shown.bs.tab', ->
    $('.js-chosen').trigger('chosen:updated')

#chosen udate for new licenses

  $(document).on 'nested:fieldAdded', ->
    $('.js-chosen').trigger('chosen:updated')


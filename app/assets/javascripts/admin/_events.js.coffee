@global ||= {}
@global.params ||= {}

@global.params.select2 =
  width: 'off'

$ ->
  $('.js-select2').select2(global.params.select2)

  $('select.js-select2-nosearch').select2(
    minimumResultsForSearch: -1
  )

  @


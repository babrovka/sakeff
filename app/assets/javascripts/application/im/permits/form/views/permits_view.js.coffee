#
class window.app.PermitsFormView
  $container: null

  constructor: (@$container) ->
    dateInput = @$container.find(".js-date-input")
    @drawDatePicker(dateInput[0]) if dateInput.length > 0


  # Draws date picker
  drawDatePicker: (dateInput) ->
    startDay = new Date().toString()

    React.renderComponent RangeDatepicker(
        start_date_input_name : 'expires_at'
        finish_date_input_name : 'finishes_at'
        can_earlier_than_today : true
        start_date_min_date : startDay
        can_earlier_than_today : false
      ), dateInput

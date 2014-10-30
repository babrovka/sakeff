# Handles interaction on permits form
class window.app.PermitsFormView
  $container: null
  $dateInput: null
  $carCheckbox: null
  $onceCheckbox: null
  $carInputs: null
  $onceCheckbox: null
  $startsAtInput: null
  $onceInputs: null
  startsAtInputName: 'permit[starts_at]'
  expiresAtInputName: 'permit[expires_at]'


  # @param $container [jQuery DOM]
  constructor: (@$container) ->
    @_prepareInputs()
    @_prepareTriggers()


  # Assigns inputs to variables and draws a datepicker
  # @note is called in constructor
  _prepareInputs: =>
    @$dateInput = @$container.find(".js-date-input")
    @$carCheckbox = @$container.find(".js-car-checkbox")
    @$carInputs = @$container.find(".js-car-inputs input")
    @_drawDatePicker()
    @$onceCheckbox = @$container.find(".js-once-checkbox")
    @$startsAtInput = @$container.find("input[name='#{@startsAtInputName}']")
    @$onceInputs = @$container.find(".js-once-inputs input")


  # Prepares checkboxes and triggers inputs where necessary
  # @note is called in constructor
  _prepareTriggers: =>
    @_triggerCarInputs()
    @_triggerStartsAtInput()
    @_bindCheckboxes()


  # Draws a date picker
  # @note is called in _prepareInputs
  _drawDatePicker: =>
    startDay = new Date().toString()
    React.renderComponent RangeDatepicker(
        start_date_input_name : @startsAtInputName
        finish_date_input_name : @expiresAtInputName
        start_date_min_date : startDay
        can_earlier_than_today : false
        start_date_value: @$dateInput.data("starts-at")
        finish_date_value: @$dateInput.data("expires-at")
      ), @$dateInput[0]



  # Attaches events to checkboxes
  # @note is called in _prepareTriggers
  _bindCheckboxes: =>
    $(document).on "change", @$carCheckbox, @_triggerCarInputs
    $(document).on "change", @$startsAtInput, @_triggerStartsAtInput


  # Triggers display of car inputs
  # @note is called on carCheckbox change and on _prepareTriggers
  _triggerCarInputs: =>
    @_triggerInput(@$carCheckbox, @$carInputs, true)


  # Triggers display of starts at input
  # @note is called on $startsAtInput change and on _prepareTriggers
  _triggerStartsAtInput: =>
    @_triggerInput(@$onceCheckbox, @$startsAtInput, false)
    @_triggerInput(@$onceCheckbox, @$onceInputs, true)


  # Triggers input according to a certain checkbox state
  # @note is called on _triggerCarInputs and _triggerStartsAtInput
  # @param $checkbox [jQuery DOM]
  # @param $input [jQuery DOM]
  # @param invert [Boolean] should input be enabled when checkbox is disabled?
  _triggerInput: ($checkbox, $input, invert) ->
    toDisable = $checkbox.attr("checked") == "checked"
    toDisable = !toDisable if invert
    $input.prop('disabled', toDisable)
    # Makes calendar icon also look disabled
    console.log $input.parents(".input-with-label").find("label")
    if toDisable
      $input.closest(".input-group").addClass("input--disabled")

      $input.parents(".input-with-label").find("label").addClass("input--disabled")
    else
      $input.closest(".input-group").removeClass("input--disabled")
      $input.parents(".input-with-label").find("label").removeClass("input--disabled")

# Displays inputs in permits form
# @note is used in PermitsFormController
class window.app.PermitsFormView
  $container: null
  $dateInput: null
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
    @_drawDatePicker() if @$dateInput.length


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
    $(document).on "change", ".js-car-checkbox", @_triggerCarInputs
    $(document).on "change", ".js-once-checkbox", @_triggerStartsAtInput


  # Triggers display of car inputs
  # @note is called on carCheckbox change and on _prepareTriggers
  _triggerCarInputs: =>
    @_triggerInput($(".js-car-checkbox"), @$container.find(".js-car-inputs input"), false)
    @_triggerInput($(".js-car-checkbox"), @$container.find(".js-car-inputs select"), false)


  # Triggers display of starts at input
  # @note is called on starts at input change and on _prepareTriggers
  _triggerStartsAtInput: =>
    @_triggerInput($(".js-once-checkbox"), @$container.find("input[name='#{@startsAtInputName}']"), true)
    @_triggerInput($(".js-once-checkbox"), @$container.find(".js-once-inputs input"), false)


  # Triggers input according to a certain checkbox state
  # @note is called on _triggerCarInputs and _triggerStartsAtInput
  # @param $checkbox [jQuery DOM]
  # @param $input [jQuery DOM]
  # @param dateInput [Boolean] if it's a date picker input
  _triggerInput: ($checkbox, $input, dateInput) ->
    toDisable = $checkbox.attr("checked") != "checked"
    toDisable = !toDisable if dateInput
    $input.prop('disabled', toDisable)
    # Makes calendar icon and a label also look disabled
    if toDisable
      $input.parents(".input-group").addClass("input--disabled") if dateInput
      $input.parents(".form-group").find("label:first-child").addClass("input--disabled")
      $input.parents(".form-group").next("._car-number").addClass("input--disabled")
    else
      $input.parents(".input-group").removeClass("input--disabled") if dateInput
      $input.parents(".form-group").find("label").removeClass("input--disabled")
      $input.parents(".form-group").next("._car-number").removeClass("input--disabled")

# Handles car number interaction
# @note is used in PermitsFormController
class window.app.CarNumberController
  $container : null
  view: null

  # @param $container [jQuery DOM]
  constructor: (@$container) ->
    @_createCarNumberView()
    @_bindInputs()


  # Creates view
  # @note is called in constructor
  _createCarNumberView: =>
    @view = React.renderComponent(
      window.app.CarNumberView(
        firstLetter: "X"
      ),
      @$container[0]
    )


  # Links car number text with input values
  # @note is called in constructor
  _bindInputs: =>
    # Validates car numbers form to number only
    $(document).on "keydown", "#permit_car_numbers", (e) ->
      return if $.inArray(e.keyCode, [
        46
        8
        9
        27
        13
        110
        190
      ]) isnt -1 or (e.keyCode is 65 and e.ctrlKey is true) or (e.keyCode >= 35 and e.keyCode <= 39) # if it's home, end, left, etc - okay
      e.preventDefault()  if (e.shiftKey or (e.keyCode < 48 or e.keyCode > 57)) and (e.keyCode < 96 or e.keyCode > 105) # if it's not a number - not okay

    $(document).on "change", "#permit_first_letter", (e) =>
      firstLetter = e.val
      @view.setState(firstLetter: firstLetter)

    $(document).on "change", "#permit_second_letter", (e) =>
      secondLetter = e.val
      @view.setState(secondLetter: secondLetter)

    $(document).on "input propertychange", "#permit_car_numbers", (e) =>
      carNumbers = e.target.value
      @view.setState(carNumbers : carNumbers)

    $(document).on "change", "#permit_third_letter", (e) =>
      thirdLetter = e.val
      @view.setState(thirdLetter: thirdLetter)

    $(document).on "input propertychange", "#permit_region", (e) =>
      region = e.target.value
      @view.setState(region: region)

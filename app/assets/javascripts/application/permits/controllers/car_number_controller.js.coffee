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
      window.app.CarNumberView(),
      @$container[0]
    )


  # Links car number text with input values
  # @note is called in constructor
  _bindInputs: =>
    $(document).on "change", "#permit_first_letter", (e) =>
      firstLetter = e.val
      @view.setState(firstLetter: firstLetter)

    $(document).on "change", "#permit_second_letter", (e) =>
      secondLetter = e.val
      console.log secondLetter
      @view.setState(secondLetter: secondLetter)

    $(document).on "input propertychange", "#permit_car_numbers", (e) =>
      carNumbers = e.target.value
      @view.setState(carNumbers: carNumbers)

    $(document).on "change", "#permit_third_letter", (e) =>
      thirdLetter = e.val
      @view.setState(thirdLetter: thirdLetter)

    $(document).on "input propertychange", "#permit_region", (e) =>
      region = e.target.value
      @view.setState(region: region)

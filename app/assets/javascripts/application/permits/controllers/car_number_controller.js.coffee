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
    $(document).on "input propertychange change", "#permit_car_number", (e) =>
      number = e.target.value
      @view.setState(number: number)

    $(document).on "input propertychange change", "#permit_region", (e) =>
      region = e.target.value
      @view.setState(region: region)

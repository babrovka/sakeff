# Handles permits form interaction
# @note is used in permits form
class window.app.PermitsFormController
  $container : null
  view: null

  # @param $container [jQuery DOM]
  constructor: (@$container) ->
    @_createPermitsFormView()
    @_createCarNumberController()


  # Creates view
  # @note is called in constructor
  _createPermitsFormView: =>
    @view = new window.app.PermitsFormView(@$container)


  # Creates controller which will handle car number
  # @note is called in constructor
  _createCarNumberController: =>
    $carNumberContainer = @$container.find("._car-number")
    new window.app.CarNumberController($carNumberContainer) if $carNumberContainer.length

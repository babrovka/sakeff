# Handles permits list interaction
# @note is used in permits index
class window.app.PermitsListController
  $container : null
  view: null

  # @param $container [jQuery DOM]
  constructor: (@$container) ->
    @_createView()


  # Creates a view
  # @note is called in constructor
  _createView: =>
    @view = new window.app.PermitsListView(@$container)

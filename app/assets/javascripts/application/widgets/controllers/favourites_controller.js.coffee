# Handles favourite units interaction
# @note is called on /dashboard
# @param $container [jQuery DOM] where to render block
class window.app.widgets.FavouritesController
  $container: null
  view: null

  constructor: (@$container) ->
    @_createView()
    @_bindModels()


  # On model sync updates view
  # @note uses models which are stored in /models folder
  # @note is called on creation
  _bindModels: =>
    window.models.units.on 'sync', =>
      unitsData = window.app.TreeInterface.getUnitsAttributes()
      @view.setState({
        unitsData: unitsData
      })


  # Creates a view
  # @note is called on create
  _createView: =>
    @view = React.renderComponent(
      window.app.widgets.FavouritesView(),
      @$container[0]
    )

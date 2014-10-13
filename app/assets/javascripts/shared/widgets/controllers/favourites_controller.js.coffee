#
# @note is called on /dashboard
# @param $container [jQuery DOM] where to render block
class window.app.FavouritesController
  $container: null
  view: null

  constructor: (@$container) ->
    @_createView()
    @_bindModels()


  #
  # @note uses models which are currently stored in /models folder
  # @note is called on creation
  _bindModels: =>
    window.models.units.on 'sync', =>
      unitsData = window.app.TreeInterface.getUnitsAttributes()
#      @view.setState({unitsData: unitsData})


  #
  # @note is called on create
  _createView: =>
    @view = React.renderComponent(
      window.app.FavouritesView(),
      @$container[0]
    )

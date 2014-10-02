#
# @note is called on /dashboard
# @param $container [jQuery DOM] where to render tv
class window.app.BubblesInfoController
  $container: null
  view: null

  constructor: (@$container) ->
    @_createView()
    @_bindModels()


  _createView: =>
    @view = React.renderComponent(
      window.app.BubblesInfoView(),
      @$container[0]
    )


  # Assigns correct callbacks for all model loads
  # @note uses models which are currently stored in /models folder
  # @note is called on creation
  _bindModels: =>
    window.models.nestedBubbles.on 'sync', (data, models) =>
      @view.setState({bubblesData: models})

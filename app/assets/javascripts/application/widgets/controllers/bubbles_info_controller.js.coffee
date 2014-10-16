# Triggers block with bubbles info
# @note is called on /dashboard
# @param $container [jQuery DOM] where to render block
class window.app.widgets.BubblesInfoController
  $container: null
  view: null

  constructor: (@$container) ->
    @_createView()
    @_bindModels()
    @_subsrcribeToWebsockets()


  # @note actions are triggered from UnitBubblesController#create/destroy
  # @note is called on create
  _subsrcribeToWebsockets: ->
    new window.app.BubbleCreateNotification("/broadcast/unit/bubble/create")
    new window.app.BubbleDestroyNotification("/broadcast/unit/bubble/destroy")


  # Renders view
  # @note is called on create
  _createView: =>
    @view = React.renderComponent(
      window.app.widgets.BubblesInfoView(),
      @$container[0]
    )


  # Assigns correct callbacks for all model loads
  # @note uses models which are currently stored in /models folder
  # @note is called on creation
  _bindModels: =>
    window.models.nestedBubbles.on 'sync', (data, models) =>
      @view.setState({bubblesData: models})

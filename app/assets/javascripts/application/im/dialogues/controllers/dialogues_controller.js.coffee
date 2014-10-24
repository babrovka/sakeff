# Controller which handles dialogues rendering and data update
# @note is created on /dialogues page
# @param @$dialoguesContainer [jQuery DOM] container to render dialogues in
class @.app.DialoguesController
  $dialoguesContainer: null
  view: null
  collection: null

  # @note subscribes to view mount so that it loads models only after view readiness
  constructor: (@$dialoguesContainer) ->
    @view = React.renderComponent(
      window.app.DialoguesView(componentDidMountCallback: @.connectModels),
      @$dialoguesContainer[0]
    )


  # Connects to websockets and fetches models
  # @note is called once when view has rendered
  connectModels: =>
    new window.app.DialoguesNotification("/broadcast/im/organizations", {}, {controller: @})

    # On collection update trigger view re-render
    window.models.dialogues.on 'sync', (__method, models) =>
      @view.setState({dialoguesData: models})

    window.models.dialogues.fetch()

# Controller which handles dialogues rendering and data update
# @note is created on /dialogues page
# @param @$dialoguesContainer [jQuery DOM] container to render dialogues in
class @.app.DialoguesController
  $dialoguesContainer: null
  view: null
  collection: null

  # @note subscribes to view mount so that it loads models only after view readiness
  constructor: (@$dialoguesContainer) ->
    PubSub.subscribe('dialoguesView.mount', @connectModels)
    @view = React.renderComponent(
      window.app.DialoguesView(controller: @),
      @$dialoguesContainer[0]
    )


  # Connects to websockets and fetches models
  # @note is called once when view has rendered
  connectModels: =>
    new window.app.DialogueNotification("/broadcast/im/organizations", {}, {controller: @})
    @collection = new window.app.dialogues()

    # On collection update trigger view re-render
    @collection.on 'sync', (__method, models) =>
      @view.setState({dialoguesData: models})

    @collection.fetch()

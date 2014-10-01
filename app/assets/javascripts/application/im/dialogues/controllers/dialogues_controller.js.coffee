# Controller which handles dialogues rendering and data update
# @note is created on /dialogues page
# @param @$dialoguesContainer [jQuery DOM] container to render dialogues in
class @.app.DialoguesController
  $dialoguesContainer: null
  view: null
  model: null

  constructor: (@$dialoguesContainer) ->
    @view = React.renderComponent(
      window.app.DialoguesView(controller: @),
      @$dialoguesContainer[0]
    )

  # Connects to websockets and fetches models
  # @note is called once when view has rendered
  connectModels: =>
    new window.app.dialogueNotification("/broadcast/im/organizations")
    @model = new window.app.dialogues()

    # On model update trigger view re-render
    @model.on 'sync', (__method, models) =>
      @view.setState({dialoguesData: models})

    @model.fetch()

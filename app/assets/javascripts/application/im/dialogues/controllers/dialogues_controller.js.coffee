class @.app.DialoguesController
  dialoguesContainer: null
  view: null
  model: null

  constructor: (@dialoguesContainer) ->
    @view = React.renderComponent(
      window.app.DialoguesView(controller: @),
      @dialoguesContainer[0]
    )

  connectModels: =>
    new window.app.dialogueNotification("/broadcast/im/organizations")
    @model = new window.app.dialogues()
    # On nested bubbles model load show bubbles and 3d
    @model.on 'sync', (__method, models) =>
      console.log "synced dialogues..."
      @view.setState({dialoguesData: models})

    # Start fetching
    @model.fetch()
    # Todo: create nice dialogue class

#     class @.app.DialoguesController
#       dialoguesContainer: null
#       view: null
#       model: null
#
#       constructor: (@dialoguesContainer) ->
#         console.log "creating DialoguesController..."
#         modelUrl = @dialoguesContainer.data("dialogues-url")
#
#     #    @model = new window.app.Dialogue(modelUrl)
#         @model = Backbone.Collection.extend(
#           model: Backbone.Model.extend()
#           url: modelUrl
#         )
#
#         @view = React.renderComponent(
#           window.app.DialoguesView(controller: @),
#           @dialoguesContainer[0]
#         )
#
#
#       connectModels: =>
#         new window.app.dialogueNotification("/broadcast/im/organizations")
#
#         console.log "connecting models..."
#         console.log "@model"
#         console.log @model
#         console.log "@model.collection"
#         console.log @model
#         # On nested bubbles model load show bubbles and 3d
#         @model.on 'sync', (__method, models) =>
#     #      console.log "synced dialogues..."
#           @view.setState({dialoguesData: models})
#
#         # Start fetching
#         @model.fetch()
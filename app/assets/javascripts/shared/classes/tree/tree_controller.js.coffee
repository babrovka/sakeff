# Loads tree and 3d in right order
# @note is loaded on /units page
class window.app.TreeController
  treeContainer: null

  constructor: (treeContainer) ->
    @treeContainer = treeContainer
    # On jstree node select send its id
    PubSub.subscribe('unit.select', @receiveSelectedNodeIdSubscriber)
    @treeContainer.on 'activate_node.jstree', @sendSelectedNodeId

    # On tree load (refresh since loaded and ready events are bugged and sometimes suck dicks)
    @treeContainer.on 'refresh.jstree', @openRootNode

    app.treeView = new app.TreeView(treeContainer)
    app.bubblesView = new app.BubblesView(treeContainer)

    @fetchModels()


  # Fetches all models and loads them in correct order
  # @note is called in constructor
  fetchModels: ->
    # On units model load show tree and fetch bubbles
    models.units.on 'sync', (__method, models) =>
      app.unitsTreeView.showUnits(__method, models)
      window.models.bubbles.fetch()

    # On all bubbles model sync load nested bubbles
    models.bubbles.on 'sync', =>
      window.models.nestedBubbles.fetch()

    # On nested bubbles model load show bubbles and 3d
    window.models.nestedBubbles.on 'sync', (__method, models) =>
      app.bubblesView.refreshBubbles(models)
      app.treeView.showThreeD()

    # Start fetching
    models.units.fetch()


  # Opens root node at tree render
  # @note is called at 'refresh.jstree' event
  openRootNode: =>
    rootId = @treeContainer.find("li").first().attr("id")
    @treeContainer.jstree("open_node", rootId)


  # Send id of selected node to 3d
  # @note is triggered on node click in jstree
  # @param e [jQuery.Event] click event
  # @param data [Object] current node data
  sendSelectedNodeId: (e, data)->
    console.log "sending unit id #{data.node.id} to unit.select channel"
    PubSub.publish('unit.select', data.node.id)


  # Receives id of selected node from 3d
  # @note is triggered on node click in 3d
  # @param channel [String] name of channel
  # @param id [Object] current node id
  receiveSelectedNodeIdSubscriber: (channel, id) =>
    console.log "received unit id #{id} from #{channel} channel"
    @treeContainer.jstree("deselect_all", true)
    @treeContainer.jstree("select_node", id)

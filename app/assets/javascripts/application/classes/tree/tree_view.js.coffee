# =require 'models/units'
# =require 'models/bubbles'

# Handles display of trees
# @param treeContainer [jQuery selector] a container for a tree
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
# @todo separate it into controller, model, etc
class @.app.TreeView
  constructor: (@treeContainer) ->
    # On jstree node select send its id
    PubSub.subscribe('unit.select', @receiveSelectedNodeIdSubscriber)
    @treeContainer.on 'activate_node.jstree', @sendSelectedNodeId

    # On tree load (refresh since loaded and ready events are bugged and sometimes suck dicks)
    @treeContainer.on 'refresh.jstree', @openRootNode


  # Shows tree on units model load
  # @note this model is located at models/units.js
  showUnits:(__method, models) =>
#    console.log 'unit model synced. showing a tree now'
    # Displays a tree in a tree container
    @treeContainer.jstree
      core:
        data: models
        themes:
          icons: false
          dots: false
      plugins: [ "sort" ]
      sort: (a, b) ->
        createdAtA = _.findWhere(models, {id: a}).created_at
        createdAtB = _.findWhere(models, {id: b}).created_at

        if createdAtA > createdAtB then 1 else -1


  # Opens root node at tree render
  # @note is called at 'refresh.jstree' event
  openRootNode: =>
    rootId = @treeContainer.find("li").first().attr("id")
    @treeContainer.jstree("open_node", rootId)


  # Send id of selected node to 3d
  # @note is triggered on node click in jstree
  # @param e [jQuery.Event] click event
  # @param data [Object] this node data
  sendSelectedNodeId: (e, data)->
    console.log "sending unit id #{data.node.id} to unit.select channel"
    PubSub.publish('unit.select', data.node.id)


  # Receives id of selected node from 3d
  # @note is triggered on node click in 3d
  # @param channel [String] name of channel
  # @param id [Object] this node id
  receiveSelectedNodeIdSubscriber: (channel, id) =>
    console.log "received unit id #{id} from #{channel} channel"
    @treeContainer.jstree("deselect_all", true)
    @treeContainer.jstree("select_node", id)
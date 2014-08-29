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
          icons: false


  # Receives id of selected node from 3d
  # @note is triggered on node click in 3d
  # @param channel [String] name of channel
  # @param id [Object] this node id
  receiveSelectedNodeIdSubscriber: (channel, id) =>
    console.log "received unit id #{id} from #{channel} channel"
    @treeContainer.jstree("deselect_all", true)
    @treeContainer.jstree("select_node", id)
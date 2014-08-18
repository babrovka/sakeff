# Handles display of trees
# @param treeContainer [jQuery selector] a container for a tree
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
class TreeHandler
  constructor: (@treeContainer) ->
#    @nodesWithBubbles = []
    # On jstree node select send its id
    @treeContainer.on 'changed.jstree', @sendId

    # On any nodes insertion into a tree check for bubbles
    @treeContainer.on 'load_node.jstree', @bubblesShow

  # Shows bubbles where needed
  bubblesShow: (_node, status) =>
    # Reject root parent node with id "#"
    dataNodes = _.reject status.instance._model.data, (node) ->
      node.id == "#"

    _.each dataNodes, (node) =>
      bubble = node.original.bubble
      # If node has a bubble render it
      if bubble
        nodeWithBubbleId = node.original.id
        # Timeout because it takes time to render and it has no callback :[
        setTimeout =>
          nodeWithBubble = @treeContainer.find($("#" + nodeWithBubbleId))
          unless nodeWithBubble.hasClass("js-has-bubble")
            nodeWithBubble.addClass("js-has-bubble")
            console.log "#{bubble.text} as type #{bubble.type}"
        , 10

  # Displays a tree in a tree container
  showTree: ->
    @treeContainer.jstree
      core:
        data:
          url: @treeContainer.attr("data-url")
          data: (node) ->
            id: node.id
        themes:
          dots: false
          icons: false

  # Send id of selected node to 3d
  # @note is triggered on node click
  # @param e [jQuery.Event] click event
  # @param data [Object] this node data
  sendId: (e, data)->
    PubSub.publish('Selected objects', data.node.id)


$ ->
  unitsTreeHandler = new TreeHandler($(".js-units-tree-container"))
  unitsTreeHandler.showTree()

  mySubscriber = (msg, data) ->
    console.log "received #{data} from #{msg} channel"

  PubSub.subscribe('Selected objects', mySubscriber)
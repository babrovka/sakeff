# Handles display of trees
# @param treeContainer [jQuery selector] a container for a tree
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
class TreeHandler
  constructor: (@treeContainer) ->
    @treeContainer.on 'changed.jstree', @send_id

  # Displays a tree in a tree container
  show_tree: ->
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
  send_id: (e, data)->
    console.log data.node.id


$ ->
  unitsTreeHandler = new TreeHandler($(".js-units-tree-container"))
  unitsTreeHandler.show_tree()
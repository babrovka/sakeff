# Handles display of trees
# @param treeContainer [jQuery selector] a container for a tree
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
class TreeHandler
  constructor: (@treeContainer) ->
    @treeContainer.on 'activate_node.jstree', @send_id

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

  # Sends id of selected node to 3d
  # @note is triggered on node click
  # @param e [jQuery.Event] click event
  # @param data [Object] this node data
  send_id: (e, data)->
    unitClickEvent = new CustomEvent "unit_selection_change",
      detail:
        id: data.node.id
    document.body.dispatchEvent(unitClickEvent)


$ ->
  unitsTreeHandler = new TreeHandler($(".js-units-tree-container"))
  unitsTreeHandler.show_tree()

  mySubscriber = (data) ->
    console.log data.detail.id
    unitsTreeHandler.treeContainer.jstree('deselect_all')
    unitsTreeHandler.treeContainer.jstree('select_node', data.detail.id)

  document.body.addEventListener('unit_selection_change', mySubscriber)
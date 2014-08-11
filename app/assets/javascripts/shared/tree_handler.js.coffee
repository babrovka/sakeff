# Handles display of trees
# @param treeContainer [jQuery selector] a container for a tree
# @note is used for Units tree rendering
# @note is using jstree http://www.jstree.com/
class TreeHandler
  constructor: (@treeContainer) ->

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


$ ->
  unitsTreeHandler = new TreeHandler($(".js-units-tree-container"))
  unitsTreeHandler.show_tree()
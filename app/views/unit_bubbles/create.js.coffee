console.log "created bubble"

formContainer = $(".js-bubble-form")
formContainer.modal("hide")
formContainer.find("form")[0].reset()
formContainer.find("select").select2('val', "")

nodeId = "<%= @bubble.unit_id %>"
node = $("#" + nodeId + ".jstree-node")
bubblesContainer = node.find(".js-node-bubbles-container")

# Adds a bubble indicator to this node
if bubblesContainer.find(".js-bubble-open").length == 0
  console.log "no bubbles indicator so adding one..."
  bubblesContainer[0].appendChild(window.app.unitsTreeHandler.createNormalBubbleContainer(nodeId))


# Adds a children indicator to all parents of this node
_.each node.parents("li"), (parent) ->
  if $(parent).find(">a .js-children-has-bubbles").length == 0
    console.log "no children indicator so adding one..."
    $(parent).find(".js-node-bubbles-container")[0]
      .appendChild(window.app.unitsTreeHandler.createChildrenHasBubblesIndicator())
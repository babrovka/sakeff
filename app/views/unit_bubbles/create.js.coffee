# Resets bubbles container for updated unit and adds bubbles indicators where necessary

console.log "created bubble"

eval "<%= j raw render partial: 'unit_bubbles/reset_form' %>"
eval "<%= j raw render partial: 'unit_bubbles/get_unit' %>"

PubSub.publish('unit.bubble.create', window.app.bubbleJSON)

# Adds a bubble indicator to this node if needed
if window.app.bubblesContainer.find(".js-bubble-open").length == 0
  console.log "no bubbles indicator so adding one..."
  window.app.bubblesContainer.prepend(
    window.app.unitsTreeHandler.createNormalBubbleContainer(window.app.unitJSON))

# Adds a children indicator to all parents of this node where necessary
_.each window.app.node.parents("li"), (parent) ->
  if $(parent).find(">a .js-children-has-bubbles").length == 0
    console.log "no children indicator so adding one..."
    $(parent).find(".js-node-bubbles-container")[0]
      .appendChild(
        window.app.unitsTreeHandler.createChildrenHasBubblesIndicator())

eval "<%= j raw render partial: 'unit_bubbles/reset_bubbles_container' %>"
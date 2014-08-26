# Resets bubbles container for updated unit and removes bubbles indicators where necessary

console.log "destroyed"

eval "<%= j raw render partial: 'unit_bubbles/get_unit' %>"
# Remove bubbles container for this unit
popoverContainer = $(".js-node-popover-container[data-unit-id=#{window.app.bubblesView.unitJSON.id}]")
popoverContainer.remove()

PubSub.publish('unit.bubble.destroy', window.app.bubblesView.bubbleJSON)

# Remove bubble indicator if there are no more bubbles
if window.app.bubblesView.unitJSON.bubbles.length == 0
  console.log "no bubbles so removing an indicator..."
  window.app.bubblesView.bubblesContainer.find(".js-bubble-open").remove()

  React.unmountComponentAtNode(popoverContainer[0])
# Or re-render it
else
  $(".popover-backdrop")[0]
    .appendChild(window.app.bubblesView.createPopoverContainer(window.app.bubblesView.unitJSON))

# Checks each parent for children-bubbles indicator and removes it where necessary
_.each window.app.bubblesView.node.parents("li"), (parent) ->
  if $(parent).find("li .js-children-has-bubbles").length == 0 && $(parent).find("li .js-bubble-open").length == 0
    console.log "this node children have got no bubbles so removing bubble indicator from parent..."
    $(parent).find(">a div .js-children-has-bubbles").remove()


eval "<%= j raw render partial: 'unit_bubbles/reset_globals' %>"
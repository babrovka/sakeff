console.log "destroyed"

unitJSON = JSON.parse "<%= j raw render( partial: 'api/units/jstree_unit.json.jbuilder', locals: { unit: @bubble.unit}) %>"
node = $("#" + unitJSON.id + ".jstree-node")
bubblesContainer = node.find(".js-node-bubbles-container")

# Remove bubble indicator if there are no more bubbles
if unitJSON.bubbles.length == 0
  console.log "no bubbles so removing an indicator..."
  bubblesContainer.find(".js-bubble-open").remove()

  popoverContainer = $(".js-node-popover-container[data-unit-id=#{unitJSON.id}]")
  React.unmountComponentAtNode(popoverContainer[0])
  $(".js-node-popover-container[data-unit-id=#{unitJSON.id}]").remove()

# Checks each parent for children-bubbles indicator and removes it where necessary
_.each node.parents("li"), (parent) ->
  if $(parent).find("li .js-children-has-bubbles").length == 0 && $(parent).find("li .js-bubble-open").length == 0
    console.log "this node children have got no bubbles so removing bubble indicator from parent..."
    $(parent).find(">a div .js-children-has-bubbles").remove()
console.log "created bubble"

formContainer = $(".js-bubble-form")
formContainer.modal("hide")
formContainer.find("form")[0].reset()
formContainer.find("select").select2('val', "")

unitJSON = JSON.parse "<%= j raw render( partial: 'api/units/jstree_unit.json.jbuilder', locals: { unit: @bubble.unit}) %>"

node = $("#" + unitJSON.id + ".jstree-node")
bubblesContainer = node.find(">a .js-node-bubbles-container")

# Adds a bubble indicator to this node
if bubblesContainer.find(".js-bubble-open").length == 0
  console.log "no bubbles indicator so adding one..."
  bubblesContainer.prepend(
    window.app.unitsTreeHandler.createNormalBubbleContainer(unitJSON))


# Adds a children indicator to all parents of this node
_.each node.parents("li"), (parent) ->
  if $(parent).find(">a .js-children-has-bubbles").length == 0
    console.log "no children indicator so adding one..."
    $(parent).find(".js-node-bubbles-container")[0]
      .appendChild(
        window.app.unitsTreeHandler.createChildrenHasBubblesIndicator())


$(".js-node-popover-container[data-unit-id=#{unitJSON.id}]").remove()

$(".popover-backdrop")[0].appendChild(window.app.unitsTreeHandler.createPopoverContainer(unitJSON))
console.log "updated bubble"

formContainer = $(".js-bubble-form")
formContainer.modal("hide")
formContainer.find("form")[0].reset()
formContainer.find("select").select2('val', "")


unitJSON = JSON.parse "<%= j raw render( partial: 'api/units/jstree_unit.json.jbuilder', locals: { unit: @bubble.unit}) %>"

node = $("#" + unitJSON.id + ".jstree-node")
bubblesContainer = node.find(".js-node-bubbles-container")

$(".js-node-popover-container[data-unit-id=#{unitJSON.id}]").remove()

$(".popover-backdrop")[0].appendChild(window.app.unitsTreeHandler.createPopoverContainer(unitJSON))
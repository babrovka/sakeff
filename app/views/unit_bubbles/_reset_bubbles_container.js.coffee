# Resets bubbles container for one unit
# @note Shared code for create/update bubbles actions

$(".js-node-popover-container[data-unit-id=#{window.app.bubblesView.unitJSON.id}]").remove()
$(".popover-backdrop")[0].appendChild(window.app.bubblesView.createPopoverContainer(window.app.bubblesView.unitJSON))
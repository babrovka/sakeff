# Gets unit json info
# @note Shared code for create/update/destroy bubbles actions

window.app.bubblesView.unitJSON = JSON.parse "<%= j raw render( partial: 'api/units/jstree_unit.json.jbuilder', locals: { unit: @bubble.unit}) %>"

window.app.bubblesView.node = $("#" + window.app.bubblesView.unitJSON.id + ".jstree-node")
window.app.bubblesView.bubblesContainer = window.app.bubblesView.node.find(">a .js-node-bubbles-container")

window.app.bubblesView.bubbleJSON = JSON.parse "<%= j raw render( partial: 'api/units/bubble.json.jbuilder', locals: { bubble: @bubble}) %>"
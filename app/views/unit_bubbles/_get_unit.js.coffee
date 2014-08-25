# Gets unit json info
# @note Shared code for create/update/destroy bubbles actions

window.app.unitJSON = JSON.parse "<%= j raw render( partial: 'api/units/jstree_unit.json.jbuilder', locals: { unit: @bubble.unit}) %>"
window.app.node = $("#" + window.app.unitJSON.id + ".jstree-node")
window.app.bubblesContainer = window.app.node.find(">a .js-node-bubbles-container")
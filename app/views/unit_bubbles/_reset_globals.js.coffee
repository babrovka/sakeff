# Resets temporary global variables so they won't pollute code
# @note Shared code for create/update/destroy bubbles actions
console.log "resetting globals"

delete window.app.bubblesView.unitJSON
delete window.app.bubblesView.node
delete window.app.bubblesView.bubbleJSON

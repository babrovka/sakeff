# Resets bubbles after bubble creation

console.log "created bubble"

eval "<%= j raw render partial: 'unit_bubbles/reset_form' %>"
$(".js-node-popover-container").remove()
window.models.bubbles.fetch()

bubbleJSON = JSON.parse "<%= j raw render( partial: 'api/unit_bubbles/bubble.json.jbuilder', locals: { bubble: @bubble}) %>"

PubSub.publish('unit.bubble.create', bubbleJSON)
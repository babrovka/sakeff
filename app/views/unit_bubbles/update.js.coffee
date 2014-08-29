# Resets form and bubbles container for updated unit

console.log "updated bubble"

eval "<%= j raw render partial: 'unit_bubbles/reset_form' %>"
$(".js-node-popover-container").remove()
window.models.bubbles.fetch()

bubbleJSON = JSON.parse "<%= j raw render( partial: 'api/unit_bubbles/bubble.json.jbuilder', locals: { bubble: @bubble}) %>"

PubSub.publish('unit.bubble.update', bubbleJSON)

# Resets bubbles container for updated unit and removes bubbles indicators where necessary

console.log "destroyed bubble"

$(".js-node-popover-container").remove()
window.models.bubbles.fetch()

bubbleJSON = JSON.parse "<%= j raw render( partial: 'api/unit_bubbles/bubble.json.jbuilder', locals: { bubble: @bubble}) %>"

PubSub.publish('unit.bubble.destroy', bubbleJSON)

# Handles update bubbles events called from websockets and updates tree
# @note uses a /broadcast/unit/bubble/update channel
# @param data [JSON] bubble data
class window.app.bubbleUpdateNotification extends window.app.NotificationModel
  did_recieve_message: (data, channel) ->
    console.log "bubble just got updated from #{channel} websockets channel"
    $(".js-node-popover-container").remove()
    window.models.bubbles.fetch()

    bubbleJSON = JSON.parse data["bubble"]
    PubSub.publish('unit.bubble.destroy', bubbleJSON)
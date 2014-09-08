# Handles destroy bubbles events called from websockets and updates tree
# @note uses a /broadcast/unit/bubble/destroy channel
# @param data [JSON] bubble data
class window.app.bubbleDestroyNotification extends window.app.NotificationModel
  did_recieve_message: (data, channel) ->
#    console.log "bubble just got destroyed from #{channel} websockets channel"
    $(".js-node-popover-container").remove()
    window.models.bubbles.fetch()

    bubbleJSON = JSON.parse data["bubble"]
    PubSub.publish('unit.bubble.destroy', bubbleJSON)
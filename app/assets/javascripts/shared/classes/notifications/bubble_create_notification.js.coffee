# Handles create bubbles events called from websockets and updates models
# @note uses a /broadcast/unit/bubble/create channel
# @param data [JSON] bubble data
class window.app.BubbleCreateNotification extends window.app.NotificationModel
  did_recieve_message: (data, channel) ->
    $(".js-node-popover-container").remove()
    window.models.bubbles.fetch()

    bubbleJSON = JSON.parse data["bubble"]
    PubSub.publish('unit.bubble.destroy', bubbleJSON)

# Handles create bubbles events called from websockets and updates models
# @note uses a /broadcast/unit/bubble/create channel
# @param data [JSON] bubble data
class window.app.BubbleCreateNotification extends window.app.NotificationModel
  did_recieve_message: (data, _channel) ->
    $(".js-node-popover-container").remove()
    bubbleJSON = JSON.parse data["bubble"]
    unitId = bubbleJSON.unit_id.toUpperCase()

    window.models.nestedBubbles.once 'sync', =>
      PubSub.publish('unit.bubble.create', unitId)

    window.models.bubbles.fetch()

# Handles create bubbles events called from websockets and updates tree
# @note uses a  channel
# @param data [JSON] bubble data
class window.app.dialogueNotification extends window.app.NotificationModel
  # Triggers ajax update on message receive
  did_recieve_message: (data, channel) ->
    @.dialoguesContainer.updateDialogues()

  _custom_constructor: (custom_params) ->
    @.dialoguesContainer = custom_params.dialoguesContainer

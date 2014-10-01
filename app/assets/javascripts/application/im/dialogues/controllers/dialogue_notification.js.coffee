# Handles create bubbles events called from websockets and updates tree
# @note uses a  channel
# @param data [JSON] bubble data
class window.app.dialogueNotification extends window.app.NotificationModel
  # Triggers ajax update on new message event
  # @note is triggered in Im::OrganizationsController#create
  did_recieve_message: (data, channel) ->
    window.app.dialoguesController.model.fetch()

# Handles dialogues updates
# @note uses a channel "/broadcast/im/organizations"
# @param custom_params
#   @param controller [DialoguesController]

class window.app.DialoguesNotification extends window.app.NotificationModel
  _custom_constructor: (custom_params) =>
    @controller = custom_params.controller

  # Triggers ajax update on new message event
  # @note is triggered in Im::OrganizationsController#create
  did_recieve_message: (data, channel) =>
    @controller.collection.fetch()

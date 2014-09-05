app.Router = Backbone.Router.extend(
  routes:
    "": "index",
    'control/clean': 'read'
    'messages': 'messages'

  index: ->
    console.log "Всем привет от индексного роута!"
  read: ->
    console.log 'route read in worked!'
  messages: ->
#    if $('._messages-page').length > 0
#      new window.app.UsersMessagesNotificationView("/broadcast/messages/"+uuid)
)

new app.Router()

Backbone.history.start(pushState: true)

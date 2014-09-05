app.Router = Backbone.Router.extend(
  routes:
    "": "index",
    'control/clean': 'read'

  index: ->
    console.log "Всем привет от индексного роута!"
  read: ->
    console.log 'route read in worked!'
)

new app.Router()

Backbone.history.start(pushState: true)

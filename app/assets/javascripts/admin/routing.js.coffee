$ ->
  app.Router = Backbone.Router.extend(
    routes:
      'superuser/units': 'units'

    units: ->
      treeContainer = $(".js-units-tree-container")
      tree = new window.app.TreeController(treeContainer)
  )

  new app.Router()
  Backbone.history.start(pushState: true)
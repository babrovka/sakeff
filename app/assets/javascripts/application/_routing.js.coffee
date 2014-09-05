$ ->
  app.Router = Backbone.Router.extend(
    routes:
      'units': 'units'

    units: ->
      treeContainer = $(".js-units-tree-container")
      tree = new window.TreeController(treeContainer)
  )

  new app.Router()

  Backbone.history.start(pushState: true)

# Loads tree and 3d in right order
# @note is loaded on /units page

$ ->
  treeContainer = $(".js-units-tree-container")
  if treeContainer.length > 0
    app.unitsTreeView = new app.TreeView(treeContainer)
    app.bubblesView = new app.BubblesView(treeContainer)

    # On units model load show tree and fetch bubbles
    models.units.on 'sync', (__method, models) =>
      app.unitsTreeView.showUnits(__method, models)
      window.models.bubbles.fetch()

    # On all bubbles model load nested bubbles
    models.bubbles.on 'sync', (__method, models) =>
      window.models.nestedBubbles.fetch()

    # On bubbles model load show bubbles and 3d
    window.models.nestedBubbles.on 'sync', (__method, models) =>
      app.bubblesView.fetchBubbles(models)

      # Load 3d only if container is present and it's not loaded already
      if $('._three-d').length > 0 && $('._three-d canvas').length == 0
        new ThreeDee('._three-d',
          marginHeight: 200,
          marginWidth: 30
        )

    # Fetch bubbles
    models.units.fetch()

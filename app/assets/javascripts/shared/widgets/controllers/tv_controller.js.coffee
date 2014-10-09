# Triggers three-d tv
# @note is called on /dashboard
# @param $container [jQuery DOM] where to render tv
class window.app.TvController
  $container: null
  view: null

  constructor: (@$container) ->
    @_bindModels()
    @_fetchData()


  # @note is called after all models are synced
  _fetchModels: =>
    models.units.fetch()


  # Assigns correct callbacks for all model loads
  # @note uses models which are currently stored in /models folder
  # @note is called on creation
  _bindModels: ->
    # On units fetch load bubbles
    models.units.on 'sync', ->
      window.models.bubbles.fetch()

    # On bubbles fetch load units bubbles connection
    models.bubbles.on 'sync', ->
      window.models.nestedBubbles.fetch()

    # On all models load create a view
    window.models.nestedBubbles.on 'sync', =>
      @view = new window.app.TvView(@)

#
# @note is called on /dashboard
class window.app.UnitsModel
  constructor: () ->
    @_bindModels()
    @_fetchModels()


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

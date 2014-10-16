# Triggers three-d tv
# @note is called on /dashboard
# @param $container [jQuery DOM] where to render tv
class window.app.widgets.TvController
  $container: null
  view: null

  constructor: (@$container) ->
    @_bindModels()


  # Assigns correct callbacks for all model loads
  # @note uses models which are currently stored in /models folder
  # @note is called on creation
  _bindModels: ->
    window.models.nestedBubbles.once 'sync', =>
      @view = new window.app.widgets.TvView(@)

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
    el = $('.js-units-content-img')[0]
    if !!el
      window.models.nestedBubbles.once 'sync', =>
        @view = new window.app.widgets.TvView(@)
        @unit_content_view = React.renderComponent(app.TreeUnitImgView(), el)

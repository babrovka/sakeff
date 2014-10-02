# Handles three-d display as a widget
# @note is created in TvController
# @param controller [TvController]
class window.app.TvView
  controller: null

  constructor: (@controller) ->
    @_renderTv(@controller.$container)


  # Renders three-d
  # @note is called on creation
  # @param $container [jQuery DOM] where to render tv
  _renderTv: ($container) =>
    if $container.find('._three-d').length > 0 && $container.find('._three-d canvas').length == 0
      new ThreeDee('._three-d',
        marginHeight: 200,
        marginWidth: 30
      )

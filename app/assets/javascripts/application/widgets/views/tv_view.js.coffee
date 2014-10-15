R = React.DOM

# Handles three-d display as a widget
# @note is created in TvController
# @param controller [TvController]
class window.app.widgets.TvView
  controller: null

  constructor: (@controller) ->
    @_renderTv(@controller.$container)
    btns_container = @controller.$container.find("._tv__filter-btns")[0]
    @_renderButtons(btns_container) unless !btns_container


  # Renders three-d
  # @note is called on creation
  # @param $container [jQuery DOM] where to render tv

  _renderTv: ($container) ->
    if $('._three-d').length
      setTimeout =>
        containerHeight = $container.outerHeight() - ($('._three-d').offset().top - $("._tv__filter-btns").offset().top)
        containerWidth = $container.outerWidth()
        if $container.find('._three-d').length > 0 && $container.find('._three-d canvas').length == 0
          window.app.threeDee = new ThreeDee('._three-d',
            sceneWidth: containerWidth,
            sceneHeight: containerHeight
          )
      ,500


  # Renders filter buttons and customizes checkboxes
  # @note is called on creation
  # @param $container [DOM] where to render
  _renderButtons: (container) ->
    React.renderComponent(
      ButtonsContainer(),
      container
    )
    $(document).checkboxes_and_radio()


  # All 3d buttons container
  # @note is called in @_renderButtons
  ButtonsContainer = React.createClass
    render: ->
      buttonsInfo = [
        {name: "ЧП и аварии", class: "_tv__filter-btn--red", htmlName: "emergency"},
        {name: "Работы", class: "_tv__filter-btn--blue", htmlName: "work"},
        {name: "Метки", class: "_tv__filter-btn--green", htmlName: "information"},
      ]
      R.div(
        {},
        [
          R.p(
            {className: "_tv__filter-btns__title"},
            "Показать на карте статусы:"
          ),
          buttonsInfo.map (button) ->
            Button(button: button)
        ]
      )


  # Filter button container
  # @note is called in @ButtonsContainer
  Button = React.createClass
    # Changes bubbles filters
    # Призывает модуль 3Д на перерисовку баблов
    # @note is called on checkbox change
    changeFilters: (e) ->
      checkbox = e.target
      toDisplayOrNot = $(checkbox).attr("checked") == 'checked'
      typeNameToShow = checkbox.id

      typeNumberToDisplay = switch typeNameToShow
        when "emergency" then 0
        when "work" then 1
        else 2

      window.app.TreeInterface.displayArray[typeNumberToDisplay] = toDisplayOrNot

      PubSub.publish('unit.bubbles.update')



    render: ->
      R.form(
        {
          className: "_tv__filter-btn #{@.props.button.class}"
        },
        R.label(
          {className: "_tv__filter-btn__label", htmlFor: @.props.button.htmlName},
          [
            R.input(
              {
                type: "checkbox",
                className: "_tv__filter-btn__checkbox",
                name: @.props.button.htmlName,
                id: @.props.button.htmlName,
                onChange: @changeFilters,
                checked: 'checked'
              }
            ),
            R.span(
              {className: "_tv__filter-btn__label__text"},
              @.props.button.name
            )
          ]
        )
      )
